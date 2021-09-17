//
//  JFUserRatingTableViewCell.swift
//  Hackfest-swvl
//
//  Created by zaktech on 5/11/18.
//  Copyright © 2018 Citrusbits. All rights reserved.
//

import UIKit

// TODO: JW - Re-write/Re-design this custom cell


enum RateCellState {
    case requestRating, requestAgain, rateUserRequestRating, rateUserRequestAgain, rateAgainRequestRating, rateAgainRequestAgain
    
    var textString: (rateTitle: String, requestTitle: String) {
        switch self {
        case .requestAgain: return ("", "REQUEST AGAIN")
        case .requestRating: return ("", "REQUEST RATING")
        case .rateUserRequestRating: return ("RATE USER", "REQUEST RATING")
        case .rateUserRequestAgain: return ("RATE USER", "REQUEST AGAIN")
        case .rateAgainRequestRating: return ("RATE AGAIN", "REQUEST RATING")
        case .rateAgainRequestAgain: return ("RATE AGAIN", "REQUEST AGAIN")
        }
    }
}

enum RateButtonAction {
    case rateUser, rateAgain, requestRating, requestAgain
}

class JFUserRatingTableViewCell: UITableViewCell {
    
    //MARK:- IBOutlets
    @IBOutlet weak var rateUserButton: JFButton!
    @IBOutlet weak var requestRatings: JFButton!
    @IBOutlet weak var requestRatingButton: JFButton!
    @IBOutlet weak var rateUserButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var requestRatingButtonConstraint: NSLayoutConstraint!
    
    //MARK:- Public properties
    var ratingState = RateCellState.rateUserRequestRating
    var cellButtonAction: ((_ action: RateButtonAction) -> Void)?
    
    //MARK:- UIViewController lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if Devices.iPhone5AndSmallDevices {
            self.rateUserButton.titleLabel?.font = UIFont.normal(fontSize: 11)
            self.requestRatings.titleLabel?.font = UIFont.normal(fontSize: 11)
            self.requestRatingButton.titleLabel?.font = UIFont.normal(fontSize: 11)
        }
    }
    
    //MARK:- User actions
    @IBAction func requestRatingButtonTap(sender: UIButton) {
        
        switch ratingState {
        case .requestRating, .rateAgainRequestRating, .rateUserRequestRating:
            cellButtonAction?(.requestRating)
        default:
            cellButtonAction?(.requestAgain)
        }
    }
    
    @IBAction func rateUserButtonTapped(sender: UIButton) {
        switch ratingState {
        case .rateUserRequestAgain, .rateUserRequestRating:
            cellButtonAction?(.rateUser)
        default:
            cellButtonAction?(.rateAgain)
        }
    }
    
    //MARK:- Helper methods
    func configureCellWithState(forProfile userProfile: JFProfile) {

        if userProfile.acceptRating {
            
            if userProfile.hasBeenRated && userProfile.hasBeenRequested {
                ratingState = .rateAgainRequestAgain
            } else if userProfile.hasBeenRequested {
                ratingState = .rateUserRequestAgain
            
            } else if userProfile.hasBeenRated {
                ratingState = .rateAgainRequestRating
            
            } else {
                ratingState = .rateUserRequestRating
            }
            
        } else {
            ratingState = userProfile.hasBeenRequested ? .requestAgain : .requestRating
        }
        
        
        
        switch ratingState {
        case .rateUserRequestRating, .rateUserRequestAgain, .rateAgainRequestAgain, .rateAgainRequestRating:
            rateUserButton.addSpacingWithTitle(spacing: 2.0, title: ratingState.textString.rateTitle)
            requestRatings.addSpacingWithTitle(spacing: 2.0, title: ratingState.textString.requestTitle)
            
            requestRatingButton.isHidden = true
            requestRatings.isHidden = false
            rateUserButton.isHidden = false
            
        case .requestRating, .requestAgain:
            requestRatingButton.isHidden = false
            requestRatings.isHidden = true
            rateUserButton.isHidden = true
            requestRatingButton.addSpacingWithTitle(spacing: 2.0, title: ratingState.textString.requestTitle)
        }
        
        // Update button state for Rate Again
        if userProfile.hasBeenRated {
            self.rateUserButton.customizeButton(titleColor: UIColor.white, backgroundColor: userProfile.canRateAgain ? UIColor.jfDarkBrown : UIColor.jfLightBrown, borderColor: UIColor.clear, withRoundCorner: true, cornerRadius: 5)
        }
        
        if userProfile.hasBeenRequested {
            self.requestRatings.customizeButton(titleColor: UIColor.white, backgroundColor: userProfile.canRequestAgain ? UIColor.jfDarkBrown : UIColor.jfLightBrown, borderColor: UIColor.clear, withRoundCorner: true, cornerRadius: 5)
            self.requestRatingButton.customizeButton(titleColor: UIColor.white, backgroundColor: userProfile.canRequestAgain ? UIColor.jfDarkBrown : UIColor.jfLightBrown, borderColor: UIColor.clear, withRoundCorner: true, cornerRadius: 5)
        }

    }
    
    @objc func resetButtonAppearanceToEnable(button: JFButton) {
           button.customizeButton(titleColor: UIColor.white, backgroundColor: UIColor.jfDarkBrown, borderColor: UIColor.clear, withRoundCorner: true, cornerRadius: 5)
    }
    
    func customAppearanceOfButton(title: String)  {
        self.rateUserButton.addSpacingWithTitle(spacing: 2.0, title: title)
        self.rateUserButton.customizeButton(titleColor: UIColor.white, backgroundColor: UIColor.jfLightBrown, borderColor: UIColor.clear, withRoundCorner: true, cornerRadius: 5)
    }
}
