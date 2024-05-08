//
//  ImagePickerDelegateProxy.swift
//  subtitlify
//
//  Created by Boris Bengus on 08/05/2024.
//

import Foundation
import UIKit

public class ImagePickerDelegateProxy: NSObject,
                                       UIImagePickerControllerDelegate,
                                       UINavigationControllerDelegate
{
    public let onFinishPickingMediaWithInfo: ((UIImagePickerController, [UIImagePickerController.InfoKey: Any]) -> Void)?
    public let onCancel: ((UIImagePickerController) -> Void)?
    
    
    // MARK: - Init
    public init(
        onFinishPickingMediaWithInfo: ((UIImagePickerController, [UIImagePickerController.InfoKey: Any]) -> Void)? = nil,
        onCancel: ((UIImagePickerController) -> Void)? = nil
    ) {
        self.onFinishPickingMediaWithInfo = onFinishPickingMediaWithInfo
        self.onCancel = onCancel
        
        super.init()
    }
    
    
    // MARK: - UIImagePickerControllerDelegate
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        onFinishPickingMediaWithInfo?(picker, info)
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        onCancel?(picker)
    }
}
