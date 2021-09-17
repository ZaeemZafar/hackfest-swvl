//
//  JFNotificationsCustomCell.swift
//  Hackfest-swvl
//
//  Created by zaktech on 4/29/18.
//  Copyright © 2018 Citrusbits. All rights reserved.
//

import UIKit

class JFNotificationsCustomCell: UITableViewCell {

    //MARK:- IBOutlets
    @IBOutlet weak var newNotificationIndicator: JFNewNotificationIndicatorView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    //MARK:- UITableViewCell lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK:- Helper methods
    override func layoutSubviews() {
        super.layoutSubviews()
        
        profileImageView.circleView()
    }
}
