//
//  JFRatingViewController.swift
//  Hackfest-swvl
//
//  Created by zaktech on 5/8/18.
//  Copyright © 2018 maskers. All rights reserved.
//

import UIKit

enum JFRatingTypes {
    case accept, anonymous, appearance, personality, intelligence
    
    func getImage(isEnabled: Bool) -> UIImage? {
        switch self {
        case .personality:
            return isEnabled ? #imageLiteral(resourceName: "personality_icon_lightred") : #imageLiteral(resourceName: "personality_icon_grey")
        case .appearance:
            return isEnabled ? #imageLiteral(resourceName: "appearance_icon_yellow") : #imageLiteral(resourceName: "appearance_icon_grey")
        case .intelligence:
            return isEnabled ? #imageLiteral(resourceName: "intelligence_bulb_icon_lightblue") : #imageLiteral(resourceName: "intellignce_bulb_icon_grey")
        default:
            return nil
        }
    }
    
    func getText() -> String {
        switch self {
        case .accept:
            return "Accept Ratings"
        case .anonymous:
            return "Accept Anonymous Ratings"
        case .appearance:
            return "Appearance"
        case .personality:
            return "Personality"
        case .intelligence:
            return "Intelligence"
        }
    }
}

class RatingTuple {
    var type: JFRatingTypes
    var enabled: Bool
    
    init(rating_type: JFRatingTypes, type_enabled: Bool = false) {
        type = rating_type
        enabled = type_enabled
    }
}

class JFRatingViewController: JFViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var ratingsTableView: UITableView!
    
    //MARK:- Public properties
    var settingsData: SettingsData?
    
    //MARK:- Computed properties
    var model: [[RatingTuple]] = [
        [RatingTuple(rating_type: .accept)],
        [RatingTuple(rating_type: .anonymous)],
        [RatingTuple(rating_type: .appearance),
         RatingTuple(rating_type: .personality),
         RatingTuple(rating_type: .intelligence)]
    ]
    
    //MARK:- UIViewController lifecycle
    deinit {
        print("Deinit called for ratings vc :)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ratingsTableView.register(identifiers: [JFSettingsCustomCell.self, JFLeftIconLabelCustomCell.self, JFFooterCustomCell.self, JFSwitchCustomCell.self])
        
        loadRatingsData()
        
        ratingsTableView.estimatedRowHeight = 100
        ratingsTableView.rowHeight = UITableViewAutomaticDimension
        ratingsTableView.dataSource = self
        ratingsTableView.delegate = self
        let cell = ratingsTableView.dequeueReusableCell(withIdentifier: "RatingFooterCell")
        ratingsTableView.tableFooterView = cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setupNavigation()
    }
    
    //MARK:- Helper methods
    func setupNavigation() {
        title = "RATINGS"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "left_arrow_grey"), style: .plain, target: self, action: #selector(backButtonTapped))
    }
    
    func loadRatingsData() {
        ratingUpdate(type: .accept, isOn: settingsData?.acceptRating ?? false)
        ratingUpdate(type: .anonymous, isOn: settingsData?.acceptAnonymousRating ?? false)
        ratingUpdate(type: .appearance, isOn: settingsData?.traitAppearance ?? false)
        ratingUpdate(type: .personality, isOn: settingsData?.traitPersonality ?? false)
        ratingUpdate(type: .intelligence, isOn: settingsData?.traitIntelligence ?? false)
    }
    
    func handleCellAction(cellState isOn:Bool, tableView: UITableView, ratingData: RatingTuple, indexPath: IndexPath) {
        let previousValue = self.model[indexPath.section][indexPath.row].enabled
        self.model[indexPath.section][indexPath.row].enabled = isOn
        
        func syncSetting() {
            tableView.reloadData()
            
            self.toggleRatings(completion: { (success) in
                if success {
                    // Do nothing in case of success as the table view has already been updated with new values
                } else {
                    // Restore to previous switch values
                    self.model[indexPath.section][indexPath.row].enabled = previousValue
                    tableView.reloadData()
                }
            })
        }
        
        // Observing change status of accept rating
        if (ratingData.type == .accept) {
            
            if isOn {
                self.turnEachPreference(isOn: true)
                syncSetting()
                
            } else {
                self.showTurnOffRatingAlert(completion: { (actionPerformed) in
                    
                    if actionPerformed {
                        self.turnEachPreference(isOn: false)
                        
                    } else {
                        self.ratingUpdate(type: .accept, isOn: true)
                    }
                    
                    syncSetting()
                })
            }
            
        } else if (ratingData.type != .anonymous) {
            
            let allTuples = self.model.flatMap({$0}).filter({$0.type != .accept && $0.type != .anonymous})
            if let _ = allTuples.filter({$0.enabled == true}).first {
                self.ratingUpdate(type: .accept, isOn: true)
                syncSetting()
                
            } else {
                self.showTurnOffRatingAlert(completion: { (actionPerformed) in
                    if actionPerformed {
                        self.ratingUpdate(type: .accept, isOn: false)
                        self.ratingUpdate(type: .anonymous, isOn: false)
                        
                    } else {
                        self.model[indexPath.section][indexPath.row].enabled = !isOn
                    }
                    
                    syncSetting()
                })
            }
        } else {
            self.model[indexPath.section][indexPath.row].enabled = isOn
            syncSetting()
        }
    }
    
    func turnEachPreference(isOn: Bool) {
        model.flatMap({$0}).forEach({$0.enabled = isOn})
    }
    
    func ratingUpdate(type: JFRatingTypes, isOn: Bool) {
        if let aRating = model.flatMap({$0}).filter({$0.type == type}).first {
            aRating.enabled = isOn
        }
    }
    
    func showTurnOffRatingAlert(completion: @escaping (_ success: Bool) -> ()) {
        JFAlertViewController.presentAlertController(with: .acceptRatings, fromViewController: self.tabBarController) { success in
            completion(success)
        }
    }
    
    @objc func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK:- UITableViewDataSource
extension JFRatingViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return model.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JFSwitchCustomCell") as! JFSwitchCustomCell
        
        let ratingData = model[indexPath.section][indexPath.row]
        
        cell.configureCell(data: ratingData) { [weak self] isOn in
            self?.handleCellAction(cellState: isOn,
                                   tableView: tableView,
                                   ratingData: ratingData,
                                   indexPath: indexPath)
        }
        
        return cell
    }
}

extension JFRatingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JFFooterCustomCell") as! JFFooterCustomCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 16.0
    }
}

//MARK:- Network calls
extension JFRatingViewController {
    func toggleRatings(completion: CompletionBlockWithBool?) {
        
        let endPoint = JFUserEndpoint.settingsToggleRatingsAcceptance(acceptRatings: model[0][0].enabled, acceptAnonymousRatings: model[1][0].enabled, traitAppearance: model[2][0].enabled, traitPersonality: model[2][1].enabled, traitIntelligence: model[2][2].enabled)
        
        JFWSAPIManager.shared.sendJFAPIRequest(apiConfig: endPoint) { [weak self] (response: JFWepAPIResponse<SettingsAPIBase>) in
            
            guard let strongSelf = self else { return }
            
            if response.success {
                completion?(true)
                
            } else {
                let alertType = (response.message == JFLocalizableConstants.NetworkError) ? AlertType.networkError : AlertType.defaultSystemAlert(message: response.message )
                
                JFAlertViewController.presentAlertController(with: alertType, fromViewController: strongSelf.tabBarController) { performAction in

                    if performAction {
                        strongSelf.toggleRatings(completion: completion)
                    } else {
                        completion?(false)
                    }
                }
            }
        }
    }
}
