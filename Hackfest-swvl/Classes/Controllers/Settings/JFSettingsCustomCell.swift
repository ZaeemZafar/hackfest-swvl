//
//  JFSettingsCustomCell.swift
//  Hackfest-swvl
//
//  Created by zaktech on 5/1/18.
//  Copyright © 2018 Citrusbits. All rights reserved.
//

import UIKit

protocol JFSwitchButtonCustomCellDelegate: class {
    func switchTapped(JFSettingsCustomCell cell: JFSettingsCustomCell, at indexPath: IndexPath)
}

class JFSettingsCustomCell: UITableViewCell {

    //MARK:- IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var switchButton: UIButton!
    @IBOutlet weak var disclosureIndicatorImage: UIImageView!
    @IBOutlet weak var countLabel: UILabel!

    //MARK:- Public properties
    weak var switchButtonCustomCellDelegate: JFSwitchButtonCustomCellDelegate?
    var switchButtonCustomCellDelegateIndexPath: IndexPath!
    
    //MARK:- UITableViewCell lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.textColor = UIColor.jfDarkGray
        countLabel.textColor = UIColor.jfLightGray
        titleLabel.font = UIFont.normal(fontSize: 16.0)
    }
    
    //MARK:- User actions
    @IBAction func switchButtonTapped(_ sender: UIButton) {
        
        switchButtonCustomCellDelegate?.switchTapped(JFSettingsCustomCell: self, at: switchButtonCustomCellDelegateIndexPath)
    }
    
    //MARK:- Helper methods
    func configureCellWithMyNetworkData(connectType: JFConnectContactsView = .contacts) {
        titleLabel.text = "\(connectType.connected == false ? "Connect " : "")" + connectType.titleText
        countLabel.isHidden = !connectType.connected
        countLabel.text = "\(connectType.itemsCount)"
        
       switchButton.isHidden = true
       disclosureIndicatorImage.isHidden = false
    }
    func configureCellDataWithInvite(isFacebookInvite: Bool = true)  {
        titleLabel.text = isFacebookInvite ? "Invite Facebook Friends" : "Invite Contacts"
        countLabel.isHidden = true
        switchButton.isHidden = true
        disclosureIndicatorImage.isHidden = false
    }
}
