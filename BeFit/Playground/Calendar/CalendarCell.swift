//
//  CalendarCell.swift
//  BeFit
//
//  Created by Evelyn on 4/26/23.
//

import Foundation
import UIKit

class CalendarCell: UICollectionViewCell{
    
    @IBOutlet weak var dayOfMonth: UILabel!
    
//    let colors = [UIColor.systemMint ] // Replace with your desired set of colors
//    var currentColorIndex = 0
//    
//    override func draw(_ rect: CGRect) {
//          let circleRect = rect.insetBy(dx: 4, dy: 4) // Adjust the inset as needed
//          let circlePath = UIBezierPath(ovalIn: circleRect)
//          colors[currentColorIndex].setFill()
//          circlePath.fill()
//
//          currentColorIndex = (currentColorIndex + 1) % colors.count
//     }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 10 // 将半径设置为所需的值
        self.layer.masksToBounds = true // 这一行确保视图不会超出圆角半径范围
    }
    
}
