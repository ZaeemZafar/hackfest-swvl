//
//  JFExpandableCustomCell.swift
//  Hackfest-swvl
//
//  Created by zaktech on 6/2/18.
//  Copyright © 2018 Citrusbits. All rights reserved.
//

import UIKit
import ExpandableCell

class JFExpandableCustomCell: ExpandableCell {
    
    //MARK:- IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    
    //MARK:- Public properties
    static let ID = "JFExpandableCustomCell"
    var currentFilter: FilterType!

    //MARK:- UITableViewCell lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(data: FilterType) {
        titleLabel.text = data.getTitleText()
        currentFilter = data
    }
}
