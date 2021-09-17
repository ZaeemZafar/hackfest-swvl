//
//  JFPrivateInfoLabelCustomCell.swift
//  Hackfest-swvl
//
//  Created by zaktech on 5/9/18.
//  Copyright © 2018 Citrusbits. All rights reserved.
//

import UIKit

class JFPrivateInfoLabelCustomCell: UITableViewCell {

    //MARK:- IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    //MARK:- UITableViewCell lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
