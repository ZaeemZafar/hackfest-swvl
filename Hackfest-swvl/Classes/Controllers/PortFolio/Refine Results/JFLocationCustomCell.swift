//
//  JFLocationCustomCell.swift
//  Hackfest-swvl
//
//  Created by zaktech on 6/1/18.
//  Copyright © 2018 maskers. All rights reserved.
//

import UIKit

protocol JFCheckBoxCustomCellDelegate: class {
    func checkBoxTapped(JFLocationCustomCell cell: JFLocationCustomCell)
    func locationValueChange(location: SelectedLocation)
}

class JFLocationCustomCell: UITableViewCell {
    
    //MARK:- IBOutlets
    @IBOutlet weak var locationSlider: JFSlider!
    @IBOutlet weak var checkBoxButton: UIButton!
    @IBOutlet weak var mi25Label: UILabel!
    @IBOutlet weak var mi50Label: UILabel!
    @IBOutlet weak var mi100Label: UILabel!
    @IBOutlet weak var mi500Label: UILabel!
    
    //MARK:- Public properties
    static let ID = "JFLocationCustomCell"
    weak var checkBoxCellDelegate: JFCheckBoxCustomCellDelegate?
    var filter = UserFilter()

    //MARK:- Computed properties
    var hasLocationAccess: Bool = false {
        didSet {
            setupUI()
        }
    }
    
    //MARK:- Overrides
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        
        hasLocationAccess = filter.distance != .miNone
        
        switch filter.distance {
        case .mi25:
            updateSliderValue(value: 0.0)
            
        case .mi50:
            updateSliderValue(value: 33.3)
            
        case .mi100:
            updateSliderValue(value: 66.6)
            
        case .mi500:
            updateSliderValue(value: 100.0)
            
        case .miNone:
            break
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    //MARK:- User actions
    @IBAction func checkBoxButtonTapped(_ sender: UIButton) {
        checkBoxCellDelegate?.checkBoxTapped(JFLocationCustomCell: self)
    }
    
    @IBAction func locationSliderDraged(_ sender: UISlider) {
        updateSliderValue(value: sender.value)
    }
    
    //MARK:- Helper methods
    
    func setupUI() {
        if hasLocationAccess {
            checkBoxButton.setImage(#imageLiteral(resourceName: "checkbox_yellow"), for: .normal)
            locationSlider.isEnabled = true
            locationSlider.thumbTintColor = UIColor.fromRGB(red: 208.0, green: 132.0, blue: 34.0)
            
        } else {
            checkBoxButton.setImage(#imageLiteral(resourceName: "uncheckbox_grey"), for: .normal)
            locationSlider.isEnabled = false
            locationSlider.thumbTintColor = UIColor.fromRGB(red: 152.0, green: 152.0, blue: 152.0)
            makeDefaultColorAllLabels()
            checkBoxCellDelegate?.locationValueChange(location: .miNone)
        }
    }
    
    @objc func sliderTapped(gestureRecognizer: UIGestureRecognizer) {
        let pointTapped: CGPoint = gestureRecognizer.location(in: self)
        
        let positionOfSlider: CGPoint = locationSlider.frame.origin
        let widthOfSlider: CGFloat = locationSlider.frame.size.width
        let newValue = ((pointTapped.x - positionOfSlider.x) * CGFloat(locationSlider.maximumValue) / widthOfSlider)
        
        updateSliderValue(value: Float(newValue))
    }
    
    func makeDefaultColorAllLabels() {
        mi25Label.textColor = UIColor.fromRGB(red: 198.0, green: 198.0, blue: 198.0)
        mi50Label.textColor = UIColor.fromRGB(red: 198.0, green: 198.0, blue: 198.0)
        mi100Label.textColor = UIColor.fromRGB(red: 198.0, green: 198.0, blue: 198.0)
        mi500Label.textColor = UIColor.fromRGB(red: 198.0, green: 198.0, blue: 198.0)
    }
    
    func updateSliderValue(value: Float) {
        switch Int(value.rounded()) {
        case 0...18:
            makeDefaultColorAllLabels()
            mi25Label.textColor = UIColor.fromRGB(red: 208.0, green: 132.0, blue: 0.0)
            locationSlider.setValue(0, animated: true)
            checkBoxCellDelegate?.locationValueChange(location: .mi25)
            
        case 19...50:
            makeDefaultColorAllLabels()
            mi50Label.textColor = UIColor.fromRGB(red: 208.0, green: 132.0, blue: 0.0)
            locationSlider.setValue(33.3, animated: true)
            checkBoxCellDelegate?.locationValueChange(location: .mi50)
            
        case 51...81:
            makeDefaultColorAllLabels()
            mi100Label.textColor = UIColor.fromRGB(red: 208.0, green: 132.0, blue: 0.0)
            locationSlider.setValue(66.6, animated: true)
            checkBoxCellDelegate?.locationValueChange(location: .mi100)
            
        case 82...100:
            makeDefaultColorAllLabels()
            mi500Label.textColor = UIColor.fromRGB(red: 208.0, green: 132.0, blue: 0.0)
            locationSlider.setValue(100, animated: true)
            checkBoxCellDelegate?.locationValueChange(location: .mi500)
            
        default:
            print("here")
            break
        }
    }
}
