//
//  ExpandableCell.swift
//  ExpandableCell
//
//  Created by Seungyoun Yi on 2017. 8. 10..
//  Copyright © 2017년 SeungyounYi. All rights reserved.
//

import UIKit

open class ExpandableCell: UITableViewCell {
    open var plusMinusImageView: UIImageView!
    private var isOpen = false

    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        initView()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    open override func awakeFromNib() {
        super.awakeFromNib()

        initView()
    }

    func initView() {
        plusMinusImageView = UIImageView()
        plusMinusImageView.image = #imageLiteral(resourceName: "plus_icon_yellow")
        //plusMinusImageView.image = UIImage(named: "expandableCell_arrow", in: Bundle(for: ExpandableCell.self), compatibleWith: nil)
        self.contentView.addSubview(plusMinusImageView)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()

        let width = self.bounds.width
        let height = self.bounds.height

        plusMinusImageView.frame = CGRect(x: width - 21 - 16, y: (height - 11)/2, width: 16, height: 16)
    }

    func open() {
        self.isOpen = true
        UIView.animate(withDuration: 0.3) {
            self.plusMinusImageView.image = #imageLiteral(resourceName: "minus_line")
            //self.plusMinusImageView.layer.transform = CATransform3DMakeRotation(CGFloat(Double.pi), 1.0, 0.0, 0.0)
        }
    }

    func close() {
        self.isOpen = false
        UIView.animate(withDuration: 0.3) {
            self.plusMinusImageView.image = #imageLiteral(resourceName: "plus_icon_yellow")
            //self.plusMinusImageView.layer.transform = CATransform3DMakeRotation(CGFloat(Double.pi), 0.0, 0.0, 0.0)
        }
    }

    open func isExpanded() -> Bool {
        return isOpen
    }
}
