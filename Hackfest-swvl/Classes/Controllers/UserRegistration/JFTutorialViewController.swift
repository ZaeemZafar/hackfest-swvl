//
//  JFTutorialViewController.swift
//  Hackfest-swvl
//
//  Created by zaktech on 4/3/18.
//  Copyright © 2018 maskers. All rights reserved.
//

import UIKit

class JFTutorialViewController: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var tutorialImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    //MARK:- Private properties
    private let numberOfLines = [5, 5, 5]
    private let images = ["logo", "connecting_people_icon_yellow", "rate_path_chart"]
    private let titles = ["Welcome to Hackfest SWVL", "Build Community & Trust", "SWVL Persona"]
    private let descriptions = ["This is the SWVL travellers community! Join the movement to create SWVL travellers equity through honesty. Use the power of honest feedback to help each other to gain trust and feel safe around other travellers.",
                        "Connect with your friends(travelled before on SEVL) & meet new ones. Rate and be rated. Experience how to create value for yourself as being a traveller of SWVL. Honest feedback is a gift; give and receive it relentlessly!",
                        "The our AI based algortihm transforms your ratings from the 9 categories and your community behaviors into your SWVL Persona. Take this oppurtunity to become a good person to travel with!"]
    
    //MARK:- Public properties
    var index: Int!
    
    //MARK:- UIViewController lifecycle
    deinit {
        print("Deinit called for tutorial :)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tutorialImageView.image = UIImage(named: images[index])
        titleLabel.text = titles[index]
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 3
        paragraphStyle.alignment = .center
        
        descriptionLabel.attributedText = NSAttributedString(string: descriptions[index], attributes: [NSAttributedStringKey.paragraphStyle: paragraphStyle])
        //descriptionLabel.attributedText =  descriptions[index].customJFLineSpacing(spacing: 2.0)
        descriptionLabel.numberOfLines = numberOfLines[index]
        descriptionLabel.minimumScaleFactor = 0.1
        descriptionLabel.adjustsFontSizeToFitWidth = true
        descriptionLabel.lineBreakMode = .byTruncatingTail
    }
}

