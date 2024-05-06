//
//  UIImage+.swift
//
//
//  Created by Boris Bengus on 17/03/2024.
//

import Foundation
import UIKit

public extension UIImage {
    class func maskedImageNamed(_ name: String, color: UIColor) -> UIImage? {
        guard let image = UIImage(named: name) else {
            return nil
        }
        let rect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        
        let format = UIGraphicsImageRendererFormat.default()
        let renderer = UIGraphicsImageRenderer(size: image.size, format: format)
        let result = renderer.image { context in
            image.draw(in: rect)
            color.set()
            context.fill(rect, blendMode: .sourceAtop)
        }
        return result
    }
}
