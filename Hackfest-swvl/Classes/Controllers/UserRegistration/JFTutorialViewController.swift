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
    private let titles = ["Welcome to Hackfest-swvl", "Connecting & Rating", "JF Index"]
    private let descriptions = ["This is the disruptive social network! Join the movement to create human brand equity through honesty. Use the power of honest feedback to help each other unlock our potential.",
                        "Connect with your friends & meet new ones. Rate and be rated. Experience how to create value for yourself and others. Honest feedback is a gift; give and receive it relentlessly!",
                        "The JF algorithm transforms your ratings from the 3 categories and your in-app social behaviors into your personal JF Index score. Embrace this number to shine, grow, and seek new opportunities!"]
    
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

