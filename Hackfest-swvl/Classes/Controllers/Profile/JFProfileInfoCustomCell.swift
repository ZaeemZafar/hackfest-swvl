//
//  JFProfileInfoCustomCell.swift
//  Hackfest-swvl
//
//  Created by zaktech on 4/26/18.
//  Copyright © 2018 Citrusbits. All rights reserved.
//

import UIKit

enum cellState: Int {
    case editProfile = 0, follow, following, requested, blocked
    
    var textString: String {
        switch self {
        case .editProfile: return "EDIT PROFILE"
        case .follow: return "+ FOLLOW"
        case .following: return "FOLLOWING"
        case .requested: return "REQUESTED"
        case .blocked: return "BLOCKED"
        }
    }
}


protocol EditProfileButtonTappedDelegate: class {
    func buttonTapped()
    func followButtonTapped()
}


class JFProfileInfoCustomCell: UITableViewCell {
    
    //MARK:- IBOutlets
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var givenLabel: UILabel!
    @IBOutlet weak var receivedLabel: UILabel!
    @IBOutlet weak var editProfileButton: JFButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var facebookImageButton: UIButton!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var locationLabelHightConstraint: NSLayoutConstraint!
    
    // TODO: Why delegate is not set optional. Making it to optional for now
    // TODO: This cell has multiple ways for event delegation!!!
//    weak var delegate: EditProfileButtonTappedDelegate?
    //MARK:- Public properties
    var cellState: cellState = .follow
    var userProfileLink = ""
    var buttonTappedForState: ((cellState) -> ())?
    
    //MARK:- Computed properties
    var profileImg: UIImageView? {
        didSet {
            if let image = profileImg?.image {
                profileImage.contentMode = .scaleAspectFill
                profileImage.image = image
            } else {
                profileImage.contentMode = .center
                profileImage.image = #imageLiteral(resourceName: "profile_icon_grey_large")
            }
        }
    }
    var givenLbl: String? {
        didSet {
            givenLabel.text = givenLbl
        }
    }
    // Developer's Note:(Started)
    // If user has disable rating for themseleves: We are force setting receive lable to show nothing even if there is a value in receivedLbl
    var ratingEnabled: Bool = false {
        didSet {
            
            if ratingEnabled == false {
                receivedLabel.text = "--"
            }
        }
    }
    var receivedLbl : String? {
        didSet {
            receivedLabel.text = receivedLbl
        }
    }
    // Developer's Note:(Ended)
    var nameLbl: String? {
        didSet {
            nameLabel.text = nameLbl
        }
    }
    var facebookImg: Bool? {
        didSet {
            facebookImageButton.isHidden = (facebookImg ?? false) ? false : true
        }
    }
    var locationLbl: String? {
        didSet {
            if locationLbl != nil {
                locationLabel.attributedText = bioLabel.attributedString(text: locationLbl!, addSpacing: 2.0)
            } else {
                locationLabel.text = ""
            }
        }
    }
    var bioLbl: String? {
        didSet {
            if bioLbl != nil {
                bioLabel.attributedText = bioLabel.attributedString(text: bioLbl!, addSpacing: 2.0)
            } else {
                bioLabel.text = ""
            }
        }
    }
    
    //MARK:- UITableViewCell lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        profileImage.circleView()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    //MARK:- User actions
    @IBAction func editButtonTapped(sender: UIButton) {
        buttonTappedForState?(cellState)
    }
    
    @IBAction func facebookImageButtonTapped(_ sender: UIButton) {
    
    }
    
    //MARK:- Helper methods
    func configureCellWithData(data: ProfileInfo, thumbnailProfileImage: Bool = false) {
        
        if let url = data.imageURL(thumbnail: thumbnailProfileImage) {
            self.profileImage.jf_setImage(withURL: url, placeholderImage: #imageLiteral(resourceName: "profile_icon_placeholder"))
        }
        
        cellState = .editProfile
        
        receivedLbl = "\(data.received)"
        givenLbl = "\(data.given)"
        
        nameLbl = data.firstName + " " + data.lastName
        locationLbl = data.location
        bioLbl = data.bio
        facebookImg = data.displayFBProfileLink
        userProfileLink = data.fbProfileLink
    }
    
    func configureCellWithData(data: JFProfile, thumbnailProfileImage: Bool = false) {

        if let url = data.imageURL(thumbnail: thumbnailProfileImage) {
            self.profileImage.jf_setImage(withURL: url, placeholderImage: #imageLiteral(resourceName: "profile_icon_placeholder"))
        }
        
        receivedLbl = "\(data.ratingsReceived)"
        ratingEnabled = data.acceptRating
        givenLbl = "\(data.ratingsGiven)"
        
        nameLbl = data.firstName + " " + data.lastName
        locationLbl = data.address
        bioLbl = data.bio
        facebookImg = data.displayFBProfileLink
        userProfileLink = data.fbProfileLink
        
        switch data.followingState {
        case .following:
            cellState = .following
            
        case .requested:
            cellState = .requested
            
        case .none:
            cellState = .follow
        }

        self.editProfileButton.addSpacingWithTitle(spacing: 2.0, title: cellState.textString)
        
        switch cellState {
            
        case .following:
            customAppearanceOfButton(title: cellState.textString)
            break
            
        case .requested, .blocked:
            self.editProfileButton.customizeButton(titleColor: UIColor.jfLightBrown, backgroundColor: UIColor.clear, borderColor: UIColor.jfLightBrown, withRoundCorner: true , cornerRadius: 5.0)
            
        case .follow:
            self.editProfileButton.customizeButton(titleColor: UIColor.jfDarkBrown, backgroundColor: UIColor.clear, borderColor: UIColor.jfLightBrown, withRoundCorner: true , cornerRadius: 5.0)
        
        case .editProfile:
            break
        }
        
    }
    
    func customAppearanceOfButton(title: String)  {
        self.editProfileButton.addSpacingWithTitle(spacing: 2.0, title: title)
        self.editProfileButton.customizeButton(titleColor: UIColor.white, backgroundColor: UIColor.jfLightBrown, borderColor: UIColor.clear, withRoundCorner: true, cornerRadius: 5)
    }
}
