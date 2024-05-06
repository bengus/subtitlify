//
//  UIView+BoundingRect.swift.swift
//
//
//  Created by Boris Bengus on 17/01/2024.
//

import Foundation
import UIKit

public extension UIView {
    static func boundingRect(of views: [UIView], keepTransform: Bool = true) -> CGRect {
        guard !views.isEmpty else {
            return .zero
        }
        let firstViewRect = views[0].getRect(keepTransform: keepTransform)
        let boundingRect = views.reduce(firstViewRect, { result, view in
            result.union(view.getRect(keepTransform: keepTransform))
        })
        
        return boundingRect
    }
    
    private func getRect(keepTransform: Bool) -> CGRect {
        if keepTransform {
            /*
             To adjust the view's position and size, we don't set the UIView's frame directly, because we want to keep the
             view's transform (UIView.transform).
             By setting the view's center and bounds we really set the frame of the non-transformed view, and this keep
             the view's transform. So view's transforms won't be affected/altered by PinLayout.
             */
            let size = bounds.size
            // See setRect(...) for details about this calculation.
            let origin = CGPoint(x: center.x - (size.width * layer.anchorPoint.x),
                                 y: center.y - (size.height * layer.anchorPoint.y))
            
            return CGRect(origin: origin, size: size)
        } else {
            return frame
        }
    }
}
