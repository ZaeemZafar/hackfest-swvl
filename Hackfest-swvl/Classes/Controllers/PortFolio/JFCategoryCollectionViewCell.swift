//
//  JFCategoryCollectionViewCell.swift
//  Hackfest-swvl
//
//  Created by Muhammad Jamil on 16/05/2017.
//  Copyright © 2017 Citrusbits. All rights reserved.
//

import UIKit

class JFCategoryCollectionViewCell: UICollectionViewCell {
    
    //MARK:- IBOutlets
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imageViewSelected: UIImageView!
    
    //MARK:- Helper methods
    func configureCellWithData(indexPath: NSIndexPath, selectedIndex: Int, categoryArray: [String]) {
        
        if indexPath.row == selectedIndex {
            self.lblTitle.textColor = UIColor.jfDarkGray
            self.imageViewSelected.isHidden = false
            self.lblTitle.font = UIFont.semiBold(fontSize: 14)
            
        } else {
            self.lblTitle.textColor = UIColor.lightGray
            self.imageViewSelected.isHidden = true
            self.lblTitle.font = UIFont.normal(fontSize: 14)
        }
        self.lblTitle.text = categoryArray[indexPath.row]
    }
}
