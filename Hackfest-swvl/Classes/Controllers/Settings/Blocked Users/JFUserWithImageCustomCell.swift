//
//  JFUserWithImageCustomCell.swift
//  Hackfest-swvl
//
//  Created by zaktech on 5/7/18.
//  Copyright © 2018 maskers. All rights reserved.
//

import UIKit

enum indexButtonType: Int {
    case redColorButton = 0
    case greenColorButton
    case arrowButton
}

enum CellType: Int {
    case postiveIndex = 0
    case negativeIndex
    case notAcceptingRating
    case requested
    case follow
    case following
    case invite
    case invited
}

protocol inviteCellDelegate: class {
    func buttonTapped(at indexPath: IndexPath)
}

class JFUserWithImageCustomCell: UITableViewCell {
    
    //MARK:- IBOutlets
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var coloredCategoriesIndexLabel: UILabel!
    @IBOutlet weak var indexoRArrowButton: UIButton!
    @IBOutlet weak var indexLabel: JFPercentageLabel!
    
    //MARK:- Public properties
    weak var delegate: inviteCellDelegate!
    var inviteButtonCellDelegateIndexPath: IndexPath!
    
    //MARK:- UITableViewCell lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        if Devices.iPhone5AndSmallDevices {
          subTitleLabel.font = UIFont.normal(fontSize: 10.0)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        userImageView.circleView()
    }
    
    //MARK:- User actions
    @IBAction func buttonTapped(sender: UIButton) {
        switch sender.tag {
            
        case CellType.invite.rawValue:
            delegate.buttonTapped(at: inviteButtonCellDelegateIndexPath)
            
        default:
            print("in Progress")
        }
    }

    //MARK:- Helper methods
    func configureCellWithBlockUserData(blockUser: JFProfile) {
        
        if let imageURL = blockUser.imageURL(thumbnail: true) {
            userImageView.jf_setImage(withURL: imageURL, placeholderImage: #imageLiteral(resourceName: "profile_icon_placeholder"))

        } else {
            userImageView.image = #imageLiteral(resourceName: "profile_icon_placeholder")
        }
        
        self.titleLabel.text = blockUser.firstName + " " + blockUser.lastName
        
        if (blockUser.acceptRating == false) {
            subTitleLabel.text = "NOT ACCEPTING RATINGS"
        } else {
            var jfIndexString = ""
            
            if blockUser.profilePrivacy == .privateProfile && blockUser.followingState != .following {
                jfIndexString = "PRIVATE"
                
            } else {
                jfIndexString = blockUser.indexMultiplier(forType: .jfIndex)?.jfimValue ?? "0000"
            }
            
            subTitleLabel.text = "JF Index: \(jfIndexString)"
        }
        self.indexoRArrowButton.isHidden = true
        self.indexLabel.isHidden = true
    }
    
    func  configureCellWithData(cellData: JFProfile, isButtonTouchEnable: Bool = false, isContactsCell: Bool = false, isFilterOn: Bool = false, filter: UserFilter = UserFilter())  {
        var cellType = CellType.follow

        switch cellData.followingState {
        case .following:
            
            if isContactsCell {
                cellType = .following
            } else {
                cellType = cellData.acceptRating ? .postiveIndex: .notAcceptingRating
            }
            
        case .requested:
            cellType = .requested
        case .none:
            cellType = .follow
        }
        
        userImageView.jf_setImage(withURL: cellData.imageURL(), placeholderImage: #imageLiteral(resourceName: "profile_icon_placeholder"))
        
        titleLabel.text = cellData.fullName
        
        if isFilterOn {
            let value: NSMutableAttributedString = NSMutableAttributedString(string: "")
            
            for anIndexMultiplier in filter.indexMultipliers.enumerated() {

                if cellData.profilePrivacy == .privateProfile && cellData.followingState != .following {
                    //value = NSMutableAttributedString(string: "N/A", attributes: [.foregroundColor: UIColor.jfLightGray, .font: UIFont.semiBold(fontSize: 12)])
                    coloredCategoriesIndexLabel.isHidden = true // to show only two labels
                    
                } else {
                    
                    var extendedValue = cellData.indexMultiplier(forType: anIndexMultiplier.element)?.indexValue ?? "0000"
                    
                    if anIndexMultiplier.offset < filter.indexMultipliers.count - 1 {
                        extendedValue += ", "
                    }
                    
                    let extendedAttributesString = NSAttributedString(string: extendedValue, attributes: [.foregroundColor : anIndexMultiplier.element.graphLineColor, .font: UIFont.semiBold(fontSize: 12)])
                    
                    value.append(extendedAttributesString)
                    coloredCategoriesIndexLabel.isHidden = false //to show three labels
                }
                
            }
            
            coloredCategoriesIndexLabel.attributedText = value
            
        } else {
            coloredCategoriesIndexLabel.attributedText = NSAttributedString(string: "")
        }
        
        let jfIndexString = cellData.indexMultiplier(forType: .jfIndex)?.jfimValue ?? "0000"
        
        if cellData.profilePrivacy == .privateProfile {
            
            switch cellData.followingState {
            case .requested, .none:
                subTitleLabel.text = "PRIVATE"
                
            case .following:
                
                if cellData.acceptRating {
                    subTitleLabel.text = "JF Index: \(jfIndexString)"
                } else {
                    subTitleLabel.text = "NOT ACCEPTING RATINGS"
                }
                
            }
            
        } else {
            
            if cellData.acceptRating {
                subTitleLabel.text = "JF Index: \(jfIndexString)"
            } else {
                subTitleLabel.text = "NOT ACCEPTING RATINGS"
            }
        }
        
        
        self.indexoRArrowButton.isUserInteractionEnabled = isButtonTouchEnable
        self.indexLabel.text = cellData.indexMultiplier(forType: .jfIndex)?.rateOFChangeString ?? ""
        
        switch cellType {
            
        case CellType.negativeIndex:
            self.indexoRArrowButton.isHidden = true
            self.indexLabel.isHidden = false
            
        case CellType.postiveIndex:
            self.indexoRArrowButton.isHidden = true
            self.indexLabel.isHidden = false
            
            
        case CellType.notAcceptingRating:
            self.indexLabel.isHidden = true
            self.indexoRArrowButton.isHidden = false
            self.indexoRArrowButton.setTitle("", for: .normal)
            self.indexoRArrowButton.customButton(backGroundColor: UIColor.clear)
            self.indexoRArrowButton.setImage(#imageLiteral(resourceName: "right_arrow_grey"), for: .normal)
            self.indexoRArrowButton.contentHorizontalAlignment = .right
            self.indexoRArrowButton.tag = CellType.notAcceptingRating.rawValue

        case CellType.requested:
            self.indexLabel.isHidden = true
            self.indexoRArrowButton.isHidden = false
            self.indexoRArrowButton.setImage(UIImage(), for: .normal)
            self.indexoRArrowButton.setTitle("REQUESTED", for: .normal)
            self.indexoRArrowButton.setTitleColor(UIColor.jfLightBrown, for: .normal)
            self.indexoRArrowButton.customButton(titleColor: UIColor.jfLightBrown, backGroundColor: UIColor.clear, borderColor: UIColor.jfLightBrown, withRoundCorner: true)
            self.indexoRArrowButton.tag = CellType.requested.rawValue
            self.indexoRArrowButton.contentHorizontalAlignment = .center

        case CellType.follow:
            self.indexLabel.isHidden = true
            self.indexoRArrowButton.isHidden = false
            self.indexoRArrowButton.setImage(UIImage(), for: .normal)
            self.indexoRArrowButton.setTitle("+ FOLLOW", for: .normal)
            self.indexoRArrowButton.setTitleColor(UIColor.white, for: .normal)
            self.indexoRArrowButton.customButton(titleColor: UIColor.white, backGroundColor: UIColor.jfDarkBrown, borderColor: UIColor.clear, withRoundCorner: true)
            self.indexoRArrowButton.tag = CellType.follow.rawValue
            self.indexoRArrowButton.contentHorizontalAlignment = .center

        case CellType.following:
            self.indexLabel.isHidden = true
            self.indexoRArrowButton.isHidden = false
            self.indexoRArrowButton.setTitle("FOLLOWING", for: .normal)
            self.indexoRArrowButton.setImage(UIImage(), for: .normal)
            self.indexoRArrowButton.setTitleColor(UIColor.jfLightBrown, for: .normal)
            self.indexoRArrowButton.customButton(titleColor: UIColor.jfLightBrown, backGroundColor: UIColor.clear, borderColor: UIColor.jfLightBrown, withRoundCorner: true)
            self.indexoRArrowButton.tag = CellType.following.rawValue
            self.indexoRArrowButton.contentHorizontalAlignment = .center

        case CellType.invite:
            self.indexLabel.isHidden = true
            self.indexoRArrowButton.isHidden = false
            self.indexoRArrowButton.setImage(UIImage(), for: .normal)
            self.indexoRArrowButton.setTitle("+ INVITE", for: .normal)
            self.indexoRArrowButton.setTitleColor(UIColor.white, for: .normal)
            self.indexoRArrowButton.customButton(titleColor: UIColor.white, backGroundColor: UIColor.jfDarkBrown, borderColor: UIColor.clear, withRoundCorner: true)
            self.indexoRArrowButton.tag = CellType.invite.rawValue
            self.indexoRArrowButton.contentHorizontalAlignment = .center

        case CellType.invited:
            self.indexLabel.isHidden = true
            self.indexoRArrowButton.isHidden = false
            self.indexoRArrowButton.setTitle("INVITED", for: .normal)
            self.indexoRArrowButton.setImage(UIImage(), for: .normal)
            self.indexoRArrowButton.setTitleColor(UIColor.jfLightBrown, for: .normal)
            self.indexoRArrowButton.customButton(titleColor: UIColor.jfLightBrown, backGroundColor: UIColor.clear, borderColor: UIColor.jfLightBrown, withRoundCorner: true)
            self.indexoRArrowButton.tag = CellType.invited.rawValue
            self.indexoRArrowButton.contentHorizontalAlignment = .center
        }
    }
    
    func  configureInviteCellWithDatas(cellData: JFContactInfo, isButtonTouchEnable: Bool = false)  {
        userImageView.image = cellData.image
        titleLabel.text = cellData.fullName
        subTitleLabel.isHidden = true
        
        isButtonTouchEnable ? (self.indexoRArrowButton.isUserInteractionEnabled = true) : (self.indexoRArrowButton.isUserInteractionEnabled = false)
        
        if cellData.status == .invited {
            self.indexLabel.isHidden = true
            self.indexoRArrowButton.isHidden = false
            self.indexoRArrowButton.setTitle("INVITED", for: .normal)
            self.indexoRArrowButton.setTitleColor(UIColor.jfLightBrown, for: .normal)
            self.indexoRArrowButton.customButton(titleColor: UIColor.jfLightBrown, backGroundColor: UIColor.clear, borderColor: UIColor.jfLightBrown, withRoundCorner: true)
            self.indexoRArrowButton.tag = CellType.invited.rawValue
            
        } else {
            self.indexLabel.isHidden = true
            self.indexoRArrowButton.isHidden = false
            self.indexoRArrowButton.setTitle("+ INVITE", for: .normal)
            self.indexoRArrowButton.setTitleColor(UIColor.white, for: .normal)
            self.indexoRArrowButton.customButton(titleColor: UIColor.white, backGroundColor: UIColor.jfDarkBrown, borderColor: UIColor.clear, withRoundCorner: true)
            self.indexoRArrowButton.tag = CellType.invite.rawValue
        }
    }
    
    func  configureInviteCellWithData(type: Int, cellData: JFFollowRequests, isButtonTouchEnable: Bool = false)  {
        
        userImageView.image = UIImage(named: cellData.profileImage!)
        titleLabel.text = cellData.name
        subTitleLabel.isHidden = true
        
        isButtonTouchEnable ? (self.indexoRArrowButton.isUserInteractionEnabled = true) : (self.indexoRArrowButton.isUserInteractionEnabled = false)
        
        switch type {
            
        case CellType.invite.rawValue:
        self.indexLabel.isHidden = true
        self.indexoRArrowButton.isHidden = false
        self.indexoRArrowButton.setTitle("+ INVITE", for: .normal)
        self.indexoRArrowButton.setTitleColor(UIColor.white, for: .normal)
        self.indexoRArrowButton.customButton(titleColor: UIColor.white, backGroundColor: UIColor.jfDarkBrown, borderColor: UIColor.clear, withRoundCorner: true)
        self.indexoRArrowButton.tag = CellType.invite.rawValue
        
        case CellType.invited.rawValue:
        self.indexLabel.isHidden = true
        self.indexoRArrowButton.isHidden = false
        self.indexoRArrowButton.setTitle("INVITED", for: .normal)
        self.indexoRArrowButton.setTitleColor(UIColor.jfLightBrown, for: .normal)
        self.indexoRArrowButton.customButton(titleColor: UIColor.jfLightBrown, backGroundColor: UIColor.clear, borderColor: UIColor.jfLightBrown, withRoundCorner: true)
        self.indexoRArrowButton.tag = CellType.invited.rawValue
        
        default:
        self.indexoRArrowButton.isHidden = true
        self.indexLabel.isHidden = false
        }
    }

    func resetState() {
        self.indexoRArrowButton.isHidden = true
        self.indexLabel.isHidden = true
    }
}
