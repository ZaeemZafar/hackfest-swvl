//
//  JFProfileImageCustomCell.swift
//  Hackfest-swvl
//
//  Created by zaktech on 5/8/18.
//  Copyright © 2018 Citrusbits. All rights reserved.
//

import UIKit

protocol JFChangePhotoCustomCellDelegate: class {
    func pickImage()
}

class JFProfileImageCustomCell: UITableViewCell {

    //MARK:- IBOutlets
    @IBOutlet weak var profileImageView: UIImageView!

    //MARK:- Public properties
    weak var imagePickerDelegate: JFChangePhotoCustomCellDelegate?
    
    //MARK:- Computed properties
    var profileImg: UIImageView? {
        didSet {
            if let image = profileImg?.image {
                profileImageView.contentMode = .scaleAspectFill
                profileImageView.image = image
            } else {
                profileImageView.contentMode = .center
                profileImageView.image = #imageLiteral(resourceName: "profile_icon_grey_large")
            }
            layoutSubviews()
        }
    }
    
    //MARK:- UITableViewCell lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        profileImageView.circleView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK:- User actions
    @IBAction func changePhotoTapped(_ sender: UIButton) {
        imagePickerDelegate?.pickImage()
    }
}
