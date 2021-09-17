//
//  CBDroarExtension.swift
//  TestProject
//
//  Created by zaktech on 5/2/18.
//  Copyright © 2018 ZakTech. All rights reserved.
//

import Foundation
import UIKit
import Droar

extension AppDelegate: DroarKnob {
    
    func droarKnobWillBeginLoading(tableView: UITableView?) {
        cells = []
    }
    
    func droarKnobTitle() -> String {
        return "maskers Droar"
    }
    
    func droarKnobPosition() -> PositionInfo {
        return PositionInfo(position: .top, priority: .high)
    }
    
    func droarKnobNumberOfCells() -> Int {
        return 8
    }
    
    func droarKnobCellForIndex(index: Int, tableView: UITableView) -> DroarCell {
        
        var cell: DroarCell
        
        switch index {
        case 0:
            cell = DroarLabelCell.create(title: "iOS Developer's", detail: "Zaeem, Jawad", allowSelection: false)
            
        case 1:
            cell = DroarLabelCell.create(title: "QA Tester", detail: "Ammad Ali", allowSelection: false)
            
        case 2:
            cell = DroarLabelCell.create(title: "Backend Developer", detail: "Zeeshan Hafeez", allowSelection: false)

        case 3:
            cell = DroarLabelCell.create(title: "Sprint", detail: "14", allowSelection: false)
            
        case 4:
            cell = DroarSwitchCell.create(title: "Location", defaultValue: UserDefaults.standard.bool(forKey: JFConstants.JFUserDefaults.droarLocationEnabled), allowSelection: false, onValueChanged: { (value) in
                UserDefaults.standard.set(value, forKey: JFConstants.JFUserDefaults.droarLocationEnabled)
                
                NotificationCenter.default.post(name: Notification.Name("DroarNotification"), object: nil, userInfo: ["value": value])
            })
            
        case 5:
            cell = DroarLabelCell.create(title: "SHOW JFI CALCULATION DATA", detail: "", allowSelection: true)
        case 6:
            cell = DroarLabelCell.create(title: "SHOW RATINGS HISTORY", detail: "", allowSelection: true)

        case 7:
            cell = DroarSwitchCell.create(title: "Facebook Disabled", defaultValue: JFConstants.facebookDisabled, allowSelection: false, onValueChanged: { (value) in
                JFConstants.facebookDisabled = value
                NotificationCenter.default.post(name: Notification.Name("DroarNotification"), object: nil, userInfo: ["value": value])
            })
            
        default:
            cell =  DroarLabelCell.create(title: "", detail: "", allowSelection: true)
        }
        
        cells.append(cell)
        
        return cell
    }
    
    func droarKnobIndexSelected(tableView: UITableView, selectedIndex: Int) {
        print("Clicked!")
        if selectedIndex == 5 {
            NotificationCenter.default.post(name: Notification.Name("DroarMultiplierNotification"), object: nil, userInfo: nil)
        } else if selectedIndex == 6 {
            NotificationCenter.default.post(name: Notification.Name("DroarRatingsHistoryNotification"), object: nil, userInfo: nil)
        }
    }
}
