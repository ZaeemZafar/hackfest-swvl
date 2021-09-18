//
//  JFSwitchCustomCell.swift
//  Hackfest-swvl
//
//  Created by zaktech on 7/20/18.
//  Copyright © 2018 maskers. All rights reserved.
//

import UIKit

typealias SwitchChanged = (Bool) -> Void

class JFSwitchCustomCell: UITableViewCell {

    //MARK:- IBOutlets
    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var toggleSwitch: UISwitch!
    @IBOutlet weak var disclosureIndicatorImageView: UIImageView!
    
    //MARK:- Public properties
    var changeEvent: SwitchChanged?
    var isOn: Bool = false
    
    //MARK:- User actions
    @IBAction func switchTapped(_ sender: UISwitch) {
        changeEvent?(sender.isOn)
    }
    
    //MARK:- Helper methods
    func configureCell(data: RatingTuple, onChange: SwitchChanged?) {
        if let image = data.type.getImage(isEnabled: data.enabled) {
            leftImageView.isHidden = false
            leftImageView.image = image
        } else {
            leftImageView.isHidden = true
        }
        isOn = data.enabled
        changeEvent = onChange
        titleLabel.text = data.type.getText()
        titleLabel.textColor = UIColor.jfDarkGray
        toggleSwitch.isOn = data.enabled
    }
    
    func configureCell(row: JFSettingRows, isOn: Bool = false, completion: SwitchChanged?) {
        if let image = row.getImage() {
            leftImageView.isHidden = false
            leftImageView.image = image
        } else {
            leftImageView.isHidden = true
        }
        disclosureIndicatorImageView.isHidden = !(row.showArrow())
        titleLabel.text = row.getRowText()
        titleLabel.textColor = row.isOrange() ? UIColor.swvlRed : UIColor.jfDarkGray
        toggleSwitch.isHidden = (row.showSwitch() == false)
        toggleSwitch.isOn = isOn
        changeEvent = completion
    }
    
    func configureCell(onChange: SwitchChanged?) {
        changeEvent = onChange
    }
}
