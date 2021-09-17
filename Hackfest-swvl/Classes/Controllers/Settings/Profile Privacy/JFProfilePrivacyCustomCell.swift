//
//  JFProfilePrivacyCustomCell.swift
//  Hackfest-swvl
//
//  Created by zaktech on 5/2/18.
//  Copyright © 2018 maskers. All rights reserved.
//

import UIKit

class JFProfilePrivacyCustomCell: UITableViewCell {

    //MARK:- IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var tickImageView: UIImageView!
    
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
    func configureCell(data: PrivacyTuple) {
       titleLabel.text = data.type.getTitleText()
       subTitleLabel.text = data.type.getSubtitleText()
       tickImageView.image = UIImage(named: data.selected ? "rating_submitted_icon_grey" : "")
    }
}
