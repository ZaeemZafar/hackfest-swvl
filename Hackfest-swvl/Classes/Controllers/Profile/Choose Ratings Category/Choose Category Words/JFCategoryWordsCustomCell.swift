//
//  JFCategoryWordsCustomCell.swift
//  Hackfest-swvl
//
//  Created by zaktech on 5/24/18.
//  Copyright © 2018 Citrusbits. All rights reserved.
//

import UIKit

class JFCategoryWordsCustomCell: UICollectionViewCell {
    
    //MARK:- IBOutlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var tickImageView: UIImageView!
    @IBOutlet weak var wordsTitleLabel: UILabel!
    
    //MARK:- UITableViewCell lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if Devices.iPhone5AndSmallDevices {
            wordsTitleLabel.font = UIFont.normal(fontSize: 11.0)
        }
    }
    
    //MARK:- Helper methods
    func configureCellWithData(indexPath: IndexPath, ratingValue: Int, selectedIndexs: [Int], wordsArray: [String]) {
        containerView.layer.cornerRadius = 4.0
        wordsTitleLabel.text = wordsArray[indexPath.row]
        containerView.backgroundColor = JFSelectedCategory.colorArray[indexPath.row]
        
        // Setting border color to following cells
        if indexPath.row == 9 || indexPath.row == 10 || indexPath.row == 11 {
            containerView.layer.borderWidth = 1.0
            containerView.layer.borderColor = UIColor.jfLightGray.cgColor
        } else {
            containerView.layer.borderWidth = 0.0
        }
        
        if selectedIndexs.contains(ratingValue) {
            selectedLayout()
            
        } else {
            defaultLayout()
        }
    }
    func defaultLayout() {
        tickImageView.isHidden = true
        wordsTitleLabel.textColor = UIColor.jfChooseWordsBlack
    }
    func selectedLayout() {
        containerView.layer.borderWidth = 0.0
        tickImageView.isHidden = false
        containerView.backgroundColor = UIColor.jfMediumBrown
        wordsTitleLabel.textColor = UIColor.white
    }
}
