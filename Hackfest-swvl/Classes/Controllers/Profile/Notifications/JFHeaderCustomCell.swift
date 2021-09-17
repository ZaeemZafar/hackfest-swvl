//
//  JFHeaderCustomCell.swift
//  Hackfest-swvl
//
//  Created by zaktech on 5/2/18.
//  Copyright © 2018 maskers. All rights reserved.
//

import UIKit

class JFHeaderCustomCell: UITableViewCell {

    //MARK:- IBOutlets
    @IBOutlet weak var headerLabel: UILabel!
    
    //MARK:- UIViewController lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
