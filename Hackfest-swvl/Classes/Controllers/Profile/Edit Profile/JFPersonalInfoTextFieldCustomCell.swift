//
//  JFPersonalInfoTextFieldCustomCell.swift
//  Hackfest-swvl
//
//  Created by zaktech on 5/8/18.
//  Copyright © 2018 maskers. All rights reserved.
//

import UIKit

class JFPersonalInfoTextFieldCustomCell: UITableViewCell {

    //MARK:- IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var userTextField: UITextField!
    
    //MARK:- Public properties
    weak var userInfoTableViewCellDelegate: JFUserInfoTableViewCellDelegate?
    
    //MARK:- UITableViewCell lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        userTextField.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK:- User actions
    @IBAction func textChanged(_ textField: UITextField) {
        self.userInfoTableViewCellDelegate?.textChanged(textfield: textField)
    }
}

// MARK: - UITextFieldDelegate
extension JFPersonalInfoTextFieldCustomCell: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.userInfoTableViewCellDelegate!.textFieldDidBeginEditing(textField: textField)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return self.userInfoTableViewCellDelegate!.textFieldShouldReturn(textField: textField)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return self.userInfoTableViewCellDelegate!.textField(textField: textField, shouldChangeCharactersIn: range, replacementString: string)
    }
}
