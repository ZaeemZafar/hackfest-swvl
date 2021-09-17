//
//  JFProfileLockedCell.swift
//  Hackfest-swvl
//
//  Created by zaktech on 5/28/18.
//  Copyright © 2018 Citrusbits. All rights reserved.
//

import UIKit

enum JFCellRatingState {
    case ratingDisabled, ratingReceiveDisabled, bothLocked, blocked
    
    var textString: String {
        switch self {
        case .ratingDisabled: return "This user is not accepting ratings."
        case .ratingReceiveDisabled: return "This user's profile is private.\n Request to follow them in order to be rated."
        case .bothLocked: return  "This user's profile is private.\n Request to follow them to rate or be rated."
        case .blocked: return ""
        }
    }
}

class JFProfileLockedCell: UITableViewCell {

    //MARK:- IBOutlets
    @IBOutlet weak var desLabel: UILabel!
    @IBOutlet weak var lockiConCenterConstraint: NSLayoutConstraint!
    
    //MARK:- UITableViewCell lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        desLabel.isHidden = false

    }

    //MARK:- Helper methods
    func configureCellWithData(state: JFCellRatingState) {
        if state == .blocked {
            
        }
        desLabel.isHidden = false
        
        desLabel.attributedText =  desLabel.attributedString(text: state.textString, addSpacing: 3.0)
        desLabel.textAlignment = .center
    }
}
