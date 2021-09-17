//
//  JFFollowRequestsConfirmCustomCell.swift
//  Hackfest-swvl
//
//  Created by zaktech on 4/29/18.
//  Copyright © 2018 Citrusbits. All rights reserved.
//

import UIKit

protocol JFConfirmButtonCustomCellDelegate: class {
    func confirmTapped(JFConfirmButtonCustomCell cell: JFFollowRequestsConfirmCustomCell, at indexPath: IndexPath)
    func deleteTapped(JFConfirmButtonCustomCell cell: JFFollowRequestsConfirmCustomCell, at indexPath: IndexPath)
}

class JFFollowRequestsConfirmCustomCell: UITableViewCell {

    //MARK:- IBOutlets
    @IBOutlet weak var profileImage: JFCircleImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var inNetworkButton: UIButton!
    @IBOutlet weak var confirmButton: JFButton!
    @IBOutlet weak var deleteButton: JFButton!
    
    //MARK:- Public properties
    weak var confirmButtonCustomCellDelegate: JFConfirmButtonCustomCellDelegate?
    weak var deleteButtonCustomCellDelegate: JFConfirmButtonCustomCellDelegate?
    var confirmButtonCustomCellDelegateIndexPath: IndexPath!
    
    //MARK:- UITableViewCell lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK:- Network calls
    @IBAction func confirmButtomTapped(_ sender: JFButton) {
        confirmButtonCustomCellDelegate?.confirmTapped(JFConfirmButtonCustomCell: self, at: confirmButtonCustomCellDelegateIndexPath)
    }
    
    @IBAction func deleteButtomTapped(_ sender: JFButton) {
        deleteButtonCustomCellDelegate?.deleteTapped(JFConfirmButtonCustomCell: self, at: confirmButtonCustomCellDelegateIndexPath)
    }
    
    //MARK:- Helper methods
    override func layoutSubviews() {
        profileImage.circleView()
        inNetworkButton.layer.cornerRadius = 4.0
        inNetworkButton.layer.borderWidth = 1.0
        inNetworkButton.layer.borderColor = UIColor.jfLightGray.cgColor
    }
}
