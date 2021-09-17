//
//  JFFAQTitleCustomCell.swift
//  Hackfest-swvl
//
//  Created by zaktech on 9/5/18.
//  Copyright © 2018 Citrusbits. All rights reserved.
//

import UIKit

class JFFAQTitleCustomCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var expandImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureCell(data: FAQData) {
        titleLabel.text = data.title
        expandImageView.image = data.opened ? #imageLiteral(resourceName: "minus_line") : #imageLiteral(resourceName: "plus_icon_yellow")
    }
}
