//
//  JFChooseCategoriesViewController.swift
//  Hackfest-swvl
//
//  Created by zaktech on 4/15/18.
//  Copyright © 2018 maskers. All rights reserved.
//

import UIKit

class JFChooseCategoriesViewController: JFViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var noneMessageLabel: UILabel!
    @IBOutlet var categoryButtons: [JFCategoryButton]!
    @IBOutlet weak var nextButton: JFButton!
    @IBOutlet weak var labelTop: NSLayoutConstraint!
    
    
    //MARK:- Public properties
    var signUpUser: JFSignUpUser!
    
    //MARK:- UIViewController lifecycle
    deinit {
        print("Deinit called for choose categories vc :)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        if Devices.iPhone5AndSmallDevices {
            labelTop.constant = Devices.name == .iphone4 ? 10 :  40
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setupNavigation()
    }
    
    //MARK:- User actions
    @IBAction func categoryButtonTapped(_ sender: JFCategoryButton) {
        if sender.tag == 103 {
            categoryButtons[0].select = false
            categoryButtons[1].select = false
            categoryButtons[2].select = false
            sender.select = !sender.select
            
            noneMessageLabel.isHidden = !sender.select
            self.signUpUser.traitNone = true
            
            self.signUpUser.traitAppearance = false
            self.signUpUser.traitPersonality = false
            self.signUpUser.traitIntelligence = false
            
        } else {
            sender.select = !sender.select
            categoryButtons[3].select = false
            noneMessageLabel.isHidden = true
            
            self.signUpUser.traitNone = false
            
            switch sender.tag {
            case 100:
                self.signUpUser.traitAppearance = sender.select
            case 101:
                self.signUpUser.traitPersonality = sender.select
            case 102:
                self.signUpUser.traitIntelligence = sender.select
                
            default:
                break
            }
            
        }
        
        for button in categoryButtons {
            if button.select {
                nextButton.isEnabled = true
                return
            } else {
                nextButton.isEnabled = false
            }
        }
    }
    
    @IBAction func nextButtonTapped(_ sender: JFButton) {
        let vc = getPrivacySettingsVC()
        vc.signUpUser = self.signUpUser
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK:- Helper methods
    func setupView() {
        // Setting initial state of Buttons
        nextButton.isEnabled = false
    }
    
    func setupNavigation() {
        title = "CATEGORIES"
        addBackButton()
    }
}
