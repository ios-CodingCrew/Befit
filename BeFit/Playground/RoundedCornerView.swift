//
//  RoundedCornerView.swift
//  BeFit
//
//  Created by Evelyn on 4/26/23.
//

import UIKit

class RoundedCornerView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.topLeft, .topRight, .bottomLeft, .bottomRight], cornerRadii: CGSize(width: 16, height: 16))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
