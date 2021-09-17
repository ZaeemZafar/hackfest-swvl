//
//  ViewController.swift
//  Hackfest-swvl
//
//  Created by Umair on 28/03/2018.
//  Copyright © 2018 Citrusbits. All rights reserved.
//

import UIKit

class ViewController: JFViewController {

    //MARK:- Outlets
    
    
    //MARK:- Properties
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setupNavigation()
    }
    
    //MARK:- NavigationBar setup
    func setupNavigation() {
        title = "CATEGORIES"
        addBackButton()
    }

    //MARK:- Navigation
    

    //MARK:- Actions
    
    
}
