//
//  JFCheckBoxCustomCell.swift
//  Hackfest-swvl
//
//  Created by zaktech on 6/2/18.
//  Copyright © 2018 Citrusbits. All rights reserved.
//

import UIKit

class JFCheckBoxCustomCell: UITableViewCell {
    
    
    
    //MARK:- IBOutlets
    @IBOutlet weak var checkBoxImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    //MARK:- Public properties
    static let ID = "JFCheckBoxCustomCell"
    var isOvalCheck: Bool!
    var currentFilter: FilterType!
    
    //MARK:- Computed properties
    var selectedCell: Bool = false {
        didSet {
            if selectedCell {
                checkBoxImageView.image = isOvalCheck ? #imageLiteral(resourceName: "check_oval_yellow") : #imageLiteral(resourceName: "checkbox_yellow")
            } else {
                checkBoxImageView.image = isOvalCheck ? #imageLiteral(resourceName: "uncheck_oval_grey") : #imageLiteral(resourceName: "uncheckbox_grey")
            }
        }
    }
    
    func configureCell(data: (cellInfo: FilterTuple, cellData: UserFilter)) {
        titleLabel.text = data.cellInfo.type.getTitleText()
        isOvalCheck = data.cellInfo.type.isOvelCheck()
        currentFilter = data.cellInfo.type
        selectedCell = data.cellData.getValue(type: data.cellInfo.type)
    }
    
    func configureCell(data: (cellInfo: FilterTuple, cellData: UserFilter, index: Int)) {
        titleLabel.text = data.cellInfo.type.getExpandedRowText()[data.index]
        isOvalCheck = data.cellInfo.type.isOvelCheck()
        currentFilter = data.cellInfo.type.getExpandedRows()[data.index]
        selectedCell = data.cellData.getValue(type: currentFilter)
    }
}
