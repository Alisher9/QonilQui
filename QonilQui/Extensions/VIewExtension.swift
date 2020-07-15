//
//  ViewExtension.swift
//  QonilQui
//
//  Created by Alisher Sattarbek on 7/15/20.
//  Copyright © 2020 AlisherSattarbek. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func roundAllCorners(cornerRadius: Double) {
        layer.cornerRadius = CGFloat(cornerRadius)
        clipsToBounds = true
    }
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }

}
