//
//  MonthLabelCell.swift
//  BeFit
//
//  Created by Evelyn on 4/11/23.
//

//import UIKit
//
//class MonthLabelCell: UICollectionViewCell {
//    static let reuseIdentifier = "MonthLabelCell"
//
//    private let monthLabel: UILabel = {
//        let label = UILabel()
//        label.textAlignment = .center
//        label.font = UIFont.systemFont(ofSize: 12)
//        return label
//    }()
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        contentView.addSubview(monthLabel)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        monthLabel.frame = contentView.bounds
//    }
//
//    func configure(with text: String) {
//        monthLabel.text = text
//    }
//}

import UIKit

class MonthLabelCell: UICollectionViewCell {
    static let reuseIdentifier = "MonthLabelCell"

    private let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        return label
    }()

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        contentView.addSubview(label)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = contentView.bounds
    }

    func configure(with text: String) {
        label.text = text
    }
}
