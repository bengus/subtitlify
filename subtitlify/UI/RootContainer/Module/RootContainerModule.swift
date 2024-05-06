//
//  RootContainerModule.swift
//  subtitlify
//
//  Created by Boris Bengus on 06/05/2024.
//

import Foundation
import UIKit

public struct RootContainerModule {
    let containerViewController: UIViewController & DisposeBag
    let moduleInput: RootContainerModuleInput
}
