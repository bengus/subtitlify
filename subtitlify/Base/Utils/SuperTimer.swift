//
//  SuperTimer.swift
//  subtitlify
//
//  Created by Boris Bengus on 06/05/2024.
//

import Foundation

public final class SuperTimer {
    private let interval: TimeInterval
    private let repeats: Bool
    private let timerQueue: DispatchQueue
    private let firedQueue: DispatchQueue
    
    private var timer: Timer?
    private var onFiredClosure: (() -> Void)?
    
    
    // MARK: - Init
    public init(
        interval: TimeInterval,
        repeats: Bool,
        timerQueue: DispatchQueue = DispatchQueue.global(qos: .background),
        firedQueue: DispatchQueue = DispatchQueue.main
    ) {
        self.interval = interval
        self.repeats = repeats
        self.timerQueue = timerQueue
        self.firedQueue = firedQueue
    }
    
    
    public func schedule(onFiredClosure: @escaping () -> Void) {
        self.reset()
        self.onFiredClosure = onFiredClosure
        timerQueue.async { [weak self] in
            guard let strongSelf = self else { return }
            
            strongSelf.timer = Timer.scheduledTimer(
                timeInterval: strongSelf.interval,
                target: strongSelf,
                selector: #selector(strongSelf.onFired),
                userInfo: nil,
                repeats: strongSelf.repeats
            )
            guard let timer = strongSelf.timer else { return }
            let runLoop = RunLoop.current
            runLoop.add(timer, forMode: .default)
            runLoop.run()
        }
    }
    
    public func reset() {
        timer?.invalidate()
        timer = nil
        onFiredClosure = nil
    }
    
    public var isRunning: Bool {
        return timer != nil
    }
    
    @objc
    private func onFired(timer: Timer) {
        firedQueue.async { [weak self] in
            self?.onFiredClosure?()
        }
    }
}
