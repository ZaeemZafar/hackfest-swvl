//
//  JFChooseCategoryCustumCell.swift
//  Hackfest-swvl
//
//  Created by zaktech on 5/23/18.
//  Copyright © 2018 maskers. All rights reserved.
//

import UIKit

class JFChooseCategoryCustumCell: UITableViewCell {
    
    //MARK:- IBOutlets
    @IBOutlet weak var categoryTitleLabel: UILabel!
    @IBOutlet weak var categoryWordsLabel: UILabel!
    
    //MARK:- Computed properties
    var title: String? {
        didSet {
            categoryTitleLabel.text = title
        }
    }
    var words: String? {
        didSet {
            if (words?.isEmpty)! {
                categoryWordsLabel.isHidden = true
            } else {
                categoryWordsLabel.isHidden = false
            }
            categoryWordsLabel.text = words
        }
    }
    
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
