//
//  JFSubmitRattingChoiceViewController.swift
//  Hackfest-swvl
//
//  Created by zaktech on 5/28/18.
//  Copyright © 2018 Citrusbits. All rights reserved.
//

import UIKit

class JFSubmitRattingChoiceViewController: JFViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    
    //MARK:- Public properties
    var ratedUser: JFProfile!
    var ratings: [CategoryTypes: [Int]]!
    
    //MARK:- UIViewController lifecycle
    deinit {
        print("Deinit called for submit ratting choice vc :)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let formattedString = NSMutableAttributedString()
        formattedString
            .normal("Looks like ")
            .bold("\(ratedUser.fullName)")
            .normal(" doesn’t accept anonymous ratings.")
        topLabel.attributedText = formattedString
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setupNavigation()
    }
    
    //MARK:- User actions
    @IBAction func yesButtonTapped(_ sender: JFButton) {
        yesBtnTapped()
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK:- Helper methods
    func setupNavigation() {
        self.navigationItem.title = "RATE"
        let leftButtomItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonPressed))
        leftButtomItem.tintColor = UIColor.jfDarkGray
        customLeftButton(button: leftButtomItem)
    }
    
    @objc func cancelButtonPressed() {
        dismiss(animated: true, completion: nil)
    }
}

//MARK:- Network calls
extension JFSubmitRattingChoiceViewController {
    func yesBtnTapped() {
        let endPoint = JFUserEndpoint.rateUser(userId: ratedUser.id, ratingCategory: ratings, isAnonymous: false)
        MBProgressHUD.showCustomHUDAddedTo(view: self.navigationController?.view, title: JFLoadingTitles.ratingUser, animated: true)
        
        JFWSAPIManager.shared.sendJFAPIRequest(apiConfig: endPoint) { [weak self] (response: JFWepAPIResponse<GenericResponse>) in
            MBProgressHUD.hides(for: self?.navigationController?.view, animated: true)
            guard let strongSelf = self else { return }
            
            if response.success {
                let vc = strongSelf.getRatingSubmittedVC()
                vc.ratedUser = strongSelf.ratedUser
                strongSelf.navigationController?.pushViewController(vc, animated: true)
                
            } else {
                let alertType = (response.message == JFLocalizableConstants.NetworkError) ? AlertType.networkError : AlertType.defaultSystemAlert(message: response.message )
                
                JFAlertViewController.presentAlertController(with: alertType, fromViewController: self) { success in
                    if success {
                        strongSelf.yesBtnTapped()
                    }
                }
            }
        }
    }
}
