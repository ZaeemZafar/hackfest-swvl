//
//  JFRatingSubmittedViewController.swift
//  Hackfest-swvl
//
//  Created by zaktech on 5/28/18.
//  Copyright © 2018 maskers. All rights reserved.
//

import UIKit

class JFRatingSubmittedViewController: JFViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    //MARK:- Public properties
    var ratedUser: JFProfile!
    
    //MARK:- UIViewController lifecycle
    deinit {
        print("Deinit called for rating submitted vc :)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = ratedUser.hasBeenRated ? "Rating Edited" : "Rating Submitted"
        descriptionLabel.text = "Your ratings have been submitted. You must wait 60 minutes before you can rate \(ratedUser.fullName) again."
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setupNavigation()
    }
    
    //MARK:- User actions
    @IBAction func doneButtonTapped(_ sender: JFButton) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- Helper methods
    func setupNavigation() {
        title = "CONFIRMATION"
        self.navigationItem.setHidesBackButton(true, animated: false)
    }
}
