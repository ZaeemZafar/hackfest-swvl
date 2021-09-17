//
//  JFFollowRequestBasicCustomCell.swift
//  Hackfest-swvl
//
//  Created by zaktech on 4/29/18.
//  Copyright © 2018 maskers. All rights reserved.
//

import UIKit

class JFFollowRequestBasicCustomCell: UITableViewCell {

    //MARK:- IBOutlets
    @IBOutlet weak var numberOfRequestsLabel: UILabel!
    
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
