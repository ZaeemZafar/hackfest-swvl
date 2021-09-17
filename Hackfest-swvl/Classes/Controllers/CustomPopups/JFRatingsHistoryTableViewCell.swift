//
//  JFRatingsHistoryTableViewCell.swift
//  Hackfest-swvl
//
//  Created by zaktech on 9/6/18.
//  Copyright © 2018 Citrusbits. All rights reserved.
//

import UIKit

class JFRatingsHistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var displayDataLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureCell(data: RatingsHistoryData) {
        let receivedDate = Date(fromString: data.updatedAt ?? "", format: .isoDateTimeMilliSec)
        let formattedString = NSMutableAttributedString()
        
        formattedString.light("Rated By: ")
            .bold("\( data.ratingGivenBy?.firstName ?? "") \(data.ratingGivenBy?.lastName ?? "")")
            
            .light("\n\nAppearance: ")
            .bold("\(data.traitAppearance1?.intValue ?? 0), \(data.traitAppearance2?.intValue ?? 0), \(data.traitAppearance3?.intValue ?? 0)")
            
            .light("\n\nPersonality: ")
            .bold("\(data.traitPersonality1?.intValue ?? 0), \(data.traitPersonality2?.intValue ?? 0), \(data.traitPersonality3?.intValue ?? 0)")
            
            .light("\n\nIntelligence: ")
            .bold("\(data.traitIntelligence1?.intValue ?? 0), \(data.traitIntelligence2?.intValue ?? 0), \(data.traitIntelligence3?.intValue ?? 0)")
            
            .light("\n\nReceived On: ")
            .bold("\(receivedDate?.toString(style: .short) ?? "N/A")")
        
        displayDataLabel.attributedText = formattedString
    }
}
