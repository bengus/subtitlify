//
//  ObservablePlayer.swift
//  subtitlify
//
//  Created by Boris Bengus on 07/05/2024.
//

import Foundation
import AVFoundation
import Combine

private let timeScale = CMTimeScale(1000)
private let time = CMTime(seconds: 0.1, preferredTimescale: timeScale)

public enum PlayerScrubState {
    case reset
    case scrubStarted
    case scrubEnded(TimeInterval)
}

/// AVPlayer wrapper to publish the current time and
/// support a slider for scrubbing.
public final class ObservablePlayer: NSObject,
                                     ObservableObject
{
    /// Display time that will be bound to the scrub slider.
    @Published
    public private(set) var displayTime: TimeInterval = 0

    /// The observed time, which may not be needed by the UI.
    @Published
    public private(set) var observedTime: TimeInterval = 0

    @Published 
    public private(set) var itemDuration: TimeInterval = 0
    private var itemDurationKVOPublisher: AnyCancellable?

    /// Publish timeControlStatus
    @Published
    public private(set) var timeControlStatus: AVPlayer.TimeControlStatus = .paused
    private var timeControlStatusKVOPublisher: AnyCancellable?

    /// The AVPlayer
    public let avPlayer: AVPlayer

    /// Time observer.
    private var periodicTimeObserver: Any?

    public var scrubState: PlayerScrubState = .reset {
        didSet {
            switch scrubState {
            case .reset:
                return
            case .scrubStarted:
                return
            case .scrubEnded(let seekTime):
                avPlayer.seek(to: CMTime(seconds: seekTime, preferredTimescale: 1000))
            }
        }
    }

    
    // MARK: - Init
    public convenience init(asset: AVURLAsset) {
        let playerItem = AVPlayerItem(asset: asset)
        let player = AVPlayer(playerItem: playerItem)
        
        self.init(avPlayer: player)
    }
    
    public init(avPlayer: AVPlayer) {
        self.avPlayer = avPlayer
        super.init()
    }

    deinit {
        stopObservation()
#if DEBUG
        print("ObservablePlayer deinit")
#endif
    }

    
    // MARK: - Playback
    public func play() {
        self.avPlayer.play()
    }

    public func pause() {
        self.avPlayer.pause()
    }
    
    public func startObservation() {
        self.addPeriodicTimeObserver()
        self.addTimeControlStatusObserver()
        self.addItemDurationPublisher()
    }
    
    public func stopObservation() {
        removePeriodicTimeObserver()
        timeControlStatusKVOPublisher?.cancel()
        itemDurationKVOPublisher?.cancel()
    }

    
    // MARK: - AVPlayer observation
    private func addPeriodicTimeObserver() {
        self.periodicTimeObserver = avPlayer.addPeriodicTimeObserver(forInterval: time, queue: .main) { [weak self] (time) in
            guard let self = self else { return }

            // Always update observed time.
            self.observedTime = time.seconds

            switch self.scrubState {
            case .reset:
                self.displayTime = time.seconds
            case .scrubStarted:
                // When scrubbing, the displayTime is bound to the Slider view, so
                // do not update it here.
                break
            case .scrubEnded(let seekTime):
                self.scrubState = .reset
                self.displayTime = seekTime
            }
        }
    }

    private func removePeriodicTimeObserver() {
        guard let periodicTimeObserver = self.periodicTimeObserver else {
            return
        }
        avPlayer.removeTimeObserver(periodicTimeObserver)
        self.periodicTimeObserver = nil
    }

    private func addTimeControlStatusObserver() {
        timeControlStatusKVOPublisher = avPlayer
            .publisher(for: \.timeControlStatus)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] (newStatus) in
                guard let self = self else { return }
                self.timeControlStatus = newStatus
            })
    }

    private func addItemDurationPublisher() {
        itemDurationKVOPublisher = avPlayer
            .publisher(for: \.currentItem?.duration)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] (newStatus) in
                guard
                    let newStatus = newStatus,
                    let self = self else
                { return }
                self.itemDuration = newStatus.seconds.isNaN ? 0 : newStatus.seconds
            })
    }
}
