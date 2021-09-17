//
//  JFShowNameOrAnonymousViewController.swift
//  Hackfest-swvl
//
//  Created by zaktech on 5/28/18.
//  Copyright © 2018 maskers. All rights reserved.
//

import UIKit

class JFShowNameOrAnonymousViewController: JFViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    
    //MARK:- Public properties
    var ratedUser: JFProfile!
    var ratings: [CategoryTypes: [Int]]!
    
    //MARK:- UIViewController lifecycle
    deinit {
        print("Deinit called for show name of anonymous vc :)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let formattedString = NSMutableAttributedString()
        formattedString
            .normal("Do you want ")
            .bold("\(ratedUser.fullName)")
            .normal(" to know you’ve rated them?")
        titleLabel.attributedText = formattedString
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setupNavigation()
    }
    
    //MARK:- User actions
    @IBAction func yesButtonTapped(_ sender: JFButton) {
        yesBtnTapped()
    }
    
    @IBAction func noButtonTapped(_ sender: UIButton) {
        noBtnTapped()
    }
    
    //MARK:- Helper methods
    func setupNavigation() {
        self.navigationItem.title = "RATE"
        let leftButtomItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonTapped))
        leftButtomItem.tintColor = UIColor.jfDarkGray
        customLeftButton(button: leftButtomItem)
    }
    
    
    @objc func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}

//MARK:- Network calls
extension JFShowNameOrAnonymousViewController {
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
    
    func noBtnTapped() {
        if ratedUser.acceptAnonymousRating {
            let endPoint = JFUserEndpoint.rateUser(userId: ratedUser.id, ratingCategory: ratings, isAnonymous: true)
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
                            strongSelf.noBtnTapped()
                        }
                    }
                }
            }
        } else {
            let vc = getSubmitRattingChoiceVC()
            vc.ratedUser = ratedUser
            vc.ratings = ratings
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
