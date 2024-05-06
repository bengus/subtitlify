//
//  HomeContainerModule.swift
//  subtitlify
//
//  Created by Boris Bengus on 06/05/2024.
//

import Foundation
import UIKit

public struct HomeContainerModule {
    let containerViewController: UIViewController & DisposeBag
    let moduleInput: HomeContainerModuleInput
}
