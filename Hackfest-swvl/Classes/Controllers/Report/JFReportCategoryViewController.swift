//
//  JFReportCategoryViewController.swift
//  Hackfest-swvl
//
//  Created by Home on 19/09/2021.
//  Copyright © 2021 Citrusbits. All rights reserved.
//

import UIKit

class JFReportCategoryViewController: UIViewController {

    // MARK: IBOutlets
    @IBOutlet weak var emergencyReportImageView: UIImageView!
    @IBOutlet weak var emergencyReportLabel: UILabel!
    
    
    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
     
        setupView()
    }
    
    func setupView() {
        navigationItem.title = "CHOOSE"
    }
    
    // MARK: User Actions
    @IBAction func emergencyReportButtonTapped(_ sender: Any) {
    }
    
    @IBAction func reportSuspeciousDriverButtonTapped(_ sender: Any) {
    }
    
    @IBAction func lostFoundButtonTapped(_ sender: Any) {
    }
    
}
