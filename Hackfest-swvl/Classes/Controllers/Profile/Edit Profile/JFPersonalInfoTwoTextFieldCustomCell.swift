//
//  JFPersonalInfoTwoTextFieldCustomCell.swift
//  Hackfest-swvl
//
//  Created by zaktech on 5/10/18.
//  Copyright © 2018 maskers. All rights reserved.
//

import UIKit

protocol JFUserInfoTableViewCellDelegate: class {
    func textFieldDidBeginEditing(textField: UITextField)
    func textFieldDidEndEditing(textField: UITextField)
    func textFieldShouldReturn(textField: UITextField) -> Bool
    func textChanged(textfield: UITextField)
    func textField(textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
}

class JFPersonalInfoTwoTextFieldCustomCell: UITableViewCell {

    //MARK:- IBOutlets
    @IBOutlet weak var firstNameTitle: UILabel!
    @IBOutlet weak var lastNameTitle: UILabel!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var firstNameCrossButton: UIButton!
    @IBOutlet weak var lastNameCrossButton: UIButton!
    
    //MARK:- Public properties
    weak var userInfoTableViewCellDelegate: JFUserInfoTableViewCellDelegate?
    
    //MARK:- UITableViewCell lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
       
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK:- User actions
    @IBAction func firstNameCrossTapped(_ sender: UIButton) {
        firstNameTextField.text = ""
        textChanged(firstNameTextField)
    }
    
    @IBAction func lastNameCrossTapped(_ sender: UIButton) {
        lastNameTextField.text = ""
        textChanged(lastNameTextField)
    }
    
    @IBAction func textChanged(_ textField: UITextField) {
        self.userInfoTableViewCellDelegate?.textChanged(textfield: textField)
    }
}



// MARK: - UITextFieldDelegate
extension JFPersonalInfoTwoTextFieldCustomCell: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.userInfoTableViewCellDelegate!.textFieldDidBeginEditing(textField: textField)
        
        (textField == firstNameTextField) ? (firstNameCrossButton.isHidden = false) : (lastNameCrossButton.isHidden = false)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return self.userInfoTableViewCellDelegate!.textFieldShouldReturn(textField: textField)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return self.userInfoTableViewCellDelegate!.textField(textField: textField, shouldChangeCharactersIn: range, replacementString: string)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.userInfoTableViewCellDelegate?.textFieldDidEndEditing(textField: textField)
        (textField == firstNameTextField) ? (firstNameCrossButton.isHidden = true) : (lastNameCrossButton.isHidden = true)
    }
}
