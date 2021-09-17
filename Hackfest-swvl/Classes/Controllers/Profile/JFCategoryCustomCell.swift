//
//  JFCategoryCustomCell.swift
//  Hackfest-swvl
//
//  Created by zaktech on 4/26/18.
//  Copyright © 2018 Citrusbits. All rights reserved.
//

import UIKit

class JFCategoryCustomCell: UITableViewCell {

    //MARK:- IBOutlets
    @IBOutlet weak var categoryIcon: UIImageView!
    @IBOutlet weak var categoryTitle: UILabel!
    @IBOutlet weak var categoryIndex: UILabel!
    @IBOutlet weak var categoryPercentage: UILabel!
    @IBOutlet weak var containerView: JFView!
    
    //MARK:- Public properties
    var isCellSelected: Bool = false
    
    //MARK:- Computed properties
    var catIcon: UIImage? {
        didSet {
            categoryIcon.circleView()
            categoryIcon.image = catIcon
        }
    }
    var catTitle: String? {
        didSet {
            categoryTitle.text = catTitle
        }
    }
    var catIndex: String? {
        didSet {
            categoryIndex.text = catIndex
        }
    }
    var catPercentage: String? {
        didSet {
            categoryPercentage.text = catPercentage
        }
    }
    
    //MARK:- UITableViewCell lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    //MARK:- Helper methods
    func configureCell(withProfile profile:ProfileInfo, forType rowType: MyProfileTableDataSourceEnum, isSelected cat_selected: Bool) {
        catIcon = rowType.indexUI.icon
        catTitle = rowType.indexUI.text
        catIndex = profile.indexMultiplier(forType: rowType.indexMultiplierType)?.indexValue
        catPercentage = profile.indexMultiplier(forType: rowType.indexMultiplierType)?.rateOFChangeString
        
        containerView.layer.borderWidth = cat_selected ? 2 : 0
        containerView.layer.borderColor = cat_selected ? rowType.highLightColor.cgColor : UIColor.clear.cgColor
    }
    
    func configureCell(withProfile profile:JFProfile, forType rowType: MyProfileTableDataSourceEnum, isSelected cat_selected: Bool) {
        catIcon = rowType.indexUI.icon
        catTitle = rowType.indexUI.text
        catIndex = profile.indexMultiplier(forType: rowType.indexMultiplierType)?.indexValue
        catPercentage = profile.indexMultiplier(forType: rowType.indexMultiplierType)?.rateOFChangeString
        
        containerView.layer.borderWidth = cat_selected ? 2 : 0
        containerView.layer.borderColor = cat_selected ? rowType.highLightColor.cgColor : UIColor.clear.cgColor
    }
}
