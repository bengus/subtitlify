//
//  PinLayout+.swift
//  subtitlify
//
//  Created by Boris Bengus on 07/05/2024.
//

import Foundation
import PinLayout

public extension PinLayout {
    @discardableResult
    func apply(_ closure: (PinLayout) -> Void) -> PinLayout {
        func context() -> String { return "apply(_ closure:)" }
        closure(self)
        return self
    }
}
