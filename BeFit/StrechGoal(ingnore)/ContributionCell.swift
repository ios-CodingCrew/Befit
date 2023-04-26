//
//  ContributionCell.swift
//  BeFit
//
//  Created by Evelyn on 4/11/23.
//

import UIKit

class ContributionCell: UICollectionViewCell {
    static let reuseIdentifier = "ContributionCell"
       
       private let colorView: UIView = {
           let view = UIView()
           view.layer.cornerRadius = 3
           view.clipsToBounds = true
           return view
       }()
       
       required init?(coder: NSCoder) {
           super.init(coder: coder)
           contentView.addSubview(colorView)
           colorView.frame = contentView.bounds
       }
       
       override func layoutSubviews() {
           super.layoutSubviews()
           colorView.frame = contentView.bounds
       }
       
       func configure(with intensity: Int) {
           let color: UIColor
           switch intensity {
           case 0:
               color = UIColor.lightGray
           case 1:
               color = UIColor.green
           case 2:
               color = UIColor.blue
           case 3:
               color = UIColor.red
           default:
               color = UIColor.lightGray
           }
           colorView.backgroundColor = color
       }
}
