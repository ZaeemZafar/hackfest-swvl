//
//  JFPersonalInfoTextViewCustomCell.swift
//  Hackfest-swvl
//
//  Created by zaktech on 5/9/18.
//  Copyright © 2018 maskers. All rights reserved.
//

import UIKit

protocol JFUserInfoTextViewCustomCellDelegate: class {
    func textViewDidBeginEditing(textView: UITextView)
    func textChanged(textView: UITextView)
    func textView(textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    func textViewDidEndEditing(textView: UITextView)
}

class JFPersonalInfoTextViewCustomCell: UITableViewCell {
    
    //MARK:- IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var editOrCrossButton: UIButton!
    
    //MARK:- Public properties
    weak var userInfoTextViewCustomCellDelegate: JFUserInfoTextViewCustomCellDelegate?

    //MARK:- Computed properties
    var detailLabel: String? {
        didSet {
            if (detailLabel?.isEmpty)! {
                bioTextView.text = "Tap here to edit..."
                bioTextView.textColor = UIColor.jfLightGray
            } else {
                bioTextView.text = detailLabel
            }
        }
    }
    
    //MARK:- UITableViewCell lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bioTextView.delegate = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    //MARK:- User actions
    @IBAction func editOrCrossButtonTapped(_ sender: UIButton) {
        bioTextView.text = ""
        textViewDidChange(bioTextView)
    }
}

// MARK: - UITextFieldDelegate
extension JFPersonalInfoTextViewCustomCell: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.userInfoTextViewCustomCellDelegate?.textViewDidBeginEditing(textView: textView)
        editOrCrossButton.isHidden = false
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return self.userInfoTextViewCustomCellDelegate!.textView(textView: textView, shouldChangeTextIn: range, replacementText: text)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.userInfoTextViewCustomCellDelegate?.textChanged(textView: textView)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.userInfoTextViewCustomCellDelegate?.textViewDidEndEditing(textView: textView)
        editOrCrossButton.isHidden = true
    }
}
