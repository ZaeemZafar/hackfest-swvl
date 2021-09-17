//
//  JFLeftIconLabelCustomCell.swift
//  Hackfest-swvl
//
//  Created by zaktech on 5/8/18.
//  Copyright © 2018 maskers. All rights reserved.
//

import UIKit

protocol JFSwitchButtonRatingsCustomCellDelegate: class {
    func switchTapped(JFSettingsCustomCell cell: JFLeftIconLabelCustomCell, at indexPath: IndexPath)
}

class JFLeftIconLabelCustomCell: UITableViewCell {

    //MARK:- IBOutlets
    @IBOutlet weak var leftIconImageView: UIImageView!
    @IBOutlet weak var switchButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    //MARK:- Public properties
    weak var switchButtonCustomCellDelegate: JFSwitchButtonRatingsCustomCellDelegate?
    var switchButtonCustomCellDelegateIndexPath: IndexPath!
    
    //MARK:- User actions
    @IBAction func switchButtonTapped(_ sender: UIButton) {
        switchButtonCustomCellDelegate?.switchTapped(JFSettingsCustomCell: self, at: switchButtonCustomCellDelegateIndexPath)
    }
}
