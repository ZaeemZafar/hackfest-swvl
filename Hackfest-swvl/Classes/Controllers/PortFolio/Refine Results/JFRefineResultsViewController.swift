//
//  JFRefineResultsViewController.swift
//  Hackfest-swvl
//
//  Created by zaktech on 6/1/18.
//  Copyright © 2018 maskers. All rights reserved.
//

import UIKit
import ExpandableCell
import CoreLocation

enum FilterType {
    case location, currentLocation, categories, appearance, intelligence, personality, ratings, viewAll, acceptingRatings, notAcceptingRatings, acceptingAnonymousRatings, peopleIHaveRated, peopleInMyPortfolio, sort, highToLow, lowToHigh, aToZ, zToA
    
    func getTitleText() -> String {
        switch self {
        case .location:
            return "Location"
        case .currentLocation:
            return "Current Location"
        case .categories:
            return "Categories"
        case .appearance:
            return "Appearance"
        case .intelligence:
            return "Intelligence"
        case .personality:
            return "Personality"
        case .ratings:
            return "Ratings"
        case .viewAll:
            return "View All"
        case .acceptingRatings:
            return "Accepting Ratings"
        case .notAcceptingRatings:
            return "Not Accepting Ratings"
        case .acceptingAnonymousRatings:
            return "Accepting Anonymous Ratings"
        case .peopleIHaveRated:
            return "People I've Rated"
        case .peopleInMyPortfolio:
            return "People In Community"
        case .sort:
            return "Sort"
        case .highToLow:
            return "JF Index: Highest - Lowest"
        case .lowToHigh:
            return "JF Index: Lowest -  Highest"
        case .aToZ:
            return "Alphabetical: A - Z"
        case .zToA:
            return "Alphabetical: Z - A"
        }
    }
    
    func getExpandedRowText() -> [String] {
        switch self {
        case .location:
            return ["Current Location"]
        case .categories:
            return ["Appearance", "Personality", "Intelligence"]
        case .ratings:
            return ["View All", "Accepting Ratings", "Not Accepting Ratings", "Accepting Anonymous Ratings"]
        case .sort:
            return ["JF Index: Highest - Lowest", "JF Index: Lowest -  Highest", "Alphabetical: A - Z", "Alphabetical: Z - A"]
        default:
            return []
        }
    }
    
    func getExpandedRows() -> [FilterType] {
        switch self {
        case .location:
            return [.ratings]
        case .categories:
            return [.appearance, .personality, .intelligence]
        case .ratings:
            return [.viewAll, .acceptingRatings, .notAcceptingRatings, .acceptingAnonymousRatings]
        case .sort:
            return [.highToLow, .lowToHigh, .aToZ, .zToA]
        default:
            return []
        }
    }
    
    func isOvelCheck() -> Bool {
        switch self {
        case .sort, .highToLow, .lowToHigh, .aToZ, .zToA:
            return true
        default:
            return false
        }
    }
}

typealias FilterTuple = (type: FilterType, selected: Bool)
typealias FilterChanged = (UserFilter) -> Void

class JFRefineResultsViewController: JFViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var refineTableView: ExpandableTableView!
    @IBOutlet weak var applyButton: JFButton!
    @IBOutlet weak var applyButtonContainerHeightConstraint: NSLayoutConstraint!
    
    //MARK:- Public properties
    var onFilterChange: FilterChanged?
    var filter = UserFilter()
    var locationManager: CLLocationManager!
    var locationCell: JFLocationCustomCell?
    var filterArray = [String]()
    var model: [[FilterTuple]] = [
        [(.location, false), (.categories, false), (.ratings, false)],
        [(.peopleIHaveRated, false)],
        [(.peopleInMyPortfolio, false)],
        [(.sort, false)]
    ]
    
    //MARK:- UIViewController lifecycle
    deinit {
        print("Deinit called for refine results vc :)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        refineTableView.expandableDelegate = self
        refineTableView.animation = .automatic
        
        refineTableView.register(identifiers: [JFExpandableCustomCell.self, JFLocationCustomCell.self, JFCheckBoxCustomCell.self, JFHeaderCustomCell.self])
        
        refineTableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setupNavigation()
        updateViewStateWithFilterSettings()
    }
    
    //MARK:- User actions
    @IBAction func applyButtonTapped(_ sender: JFButton) {
        filter.filterActive = true
        onFilterChange?(filter)
        dismiss(animated: true, completion: nil)
    }
    
    //MARK:- Helper methods
    func setupNavigation() {
        title = "REFINE RESULTS"
        let leftButtomItem = UIBarButtonItem(image: #imageLiteral(resourceName: "cross_icon_grey"), style: .plain, target: self, action: #selector(crossButtonTapped))
        leftButtomItem.tintColor = UIColor.jfDarkGray
        customLeftButton(button: leftButtomItem)
        
        let rightButtomItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(resetButtonTapped))
        
        rightButtomItem.tintColor = UIColor.jfDarkGray
        customRightButton(button: rightButtomItem)
    }
    
    func updateViewStateWithFilterSettings() {
        
        if filter.hasFiltersToApply() {
            applyButtonContainerHeightConstraint.constant = 80
            applyButton.isHidden = false
            
        } else {
            applyButtonContainerHeightConstraint.constant = 0
            applyButton.isHidden = true
        }
        
        self.navigationItem.rightBarButtonItem?.isEnabled = filter.hasFiltersToApply()
    }
    
    @objc func crossButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func resetButtonTapped() {
        
        UIAlertController.showAlert(inViewController: self, title: "Confirmation", message: "All applied filters will be removed and the search results will be reset to default, are you sure want to continue with reset?", okButtonTitle: "Reset", cancelButtonTitle: "Cancel") { [weak self] (success) in
            
            if success {
                guard let strongSelf = self else { return }
                strongSelf.filter.reset()
                strongSelf.updateViewStateWithFilterSettings()
                
                strongSelf.refineTableView.reloadData()
                
                strongSelf.onFilterChange?(strongSelf.filter)
            }
        }
    }
}

//MARK:- ExpandableDelegate
extension JFRefineResultsViewController: ExpandableDelegate {
    
    func numberOfSections(in tableView: ExpandableTableView) -> Int {
        return model.count
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, numberOfRowsInSection section: Int) -> Int {
        return model[section].count
    }
    
    // Provide Expanded cells data here
    func expandableTableView(_ expandableTableView: ExpandableTableView, expandedCellsForRowAt indexPath: IndexPath) -> [UITableViewCell]? {
        let aTuple = model[indexPath.section][indexPath.row]
        var expandableCells = [UITableViewCell]()
        
        for i in 0..<(aTuple.type.getExpandedRowText().count) {
            
            if aTuple.type == .location {
                let locationCustomCell = expandableTableView.dequeueReusableCell(withIdentifier: JFLocationCustomCell.ID) as! JFLocationCustomCell
                locationCustomCell.filter = filter
                locationCustomCell.checkBoxCellDelegate = self
                expandableCells.append(locationCustomCell)
                
            } else {
                let checkBoxCell = expandableTableView.dequeueReusableCell(withIdentifier: JFCheckBoxCustomCell.ID) as! JFCheckBoxCustomCell
                
                checkBoxCell.configureCell(data: (aTuple, filter, i))
                
                expandableCells.append(checkBoxCell)
            }
        }
        return expandableCells
    }
    
    //Provide Expandable cell
    func expandableTableView(_ expandableTableView: ExpandableTableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let filterData = model[indexPath.section][indexPath.row]
        
        if let cell = chooseCell(cellType: filterData)  {
            return cell
        }
        
        return UITableViewCell()
    }
    
    func chooseCell(cellType: FilterTuple) -> UITableViewCell? {
        switch cellType.type {
        case .peopleIHaveRated, .peopleInMyPortfolio:
            return getCheckBoxCell(cellData: (cellType, filter))
        default:
            return getExpandableCell(cellData: cellType.type)
        }
    }
    
    func getExpandableCell(cellData: FilterType) -> UITableViewCell{
        let cell = refineTableView.dequeueReusableCell(withIdentifier: JFExpandableCustomCell.ID) as! JFExpandableCustomCell
        cell.configureCell(data: cellData)
        return cell
    }
    func getCheckBoxCell(cellData: (FilterTuple, UserFilter)) -> UITableViewCell {
        let cell = refineTableView.dequeueReusableCell(withIdentifier: JFCheckBoxCustomCell.ID) as! JFCheckBoxCustomCell
        cell.configureCell(data: cellData)
        return cell
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    
    //Provide here expanded cells height
    func expandableTableView(_ expandableTableView: ExpandableTableView, heightsForExpandedRowAt indexPath: IndexPath) -> [CGFloat]? {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                return [140]
                
            case 1:
                return [48, 48, 48]
                
            case 2:
                return [48, 48, 48, 48]
                
            default:
                break
            }
        case 3:
            return [48, 48, 48, 48]
        default:
            break
        }
        return nil
    }
    
    // these are unexpanded rows
    func expandableTableView(_ expandableTableView: ExpandableTableView, didSelectRowAt indexPath: IndexPath) {
        //expandableTableView.closeAll()
        print("didSelectRow:\(indexPath)")
        
        if let cell = expandableTableView.cellForRow(at: indexPath) as? JFExpandableCustomCell {
            filter.updateValue(type: cell.currentFilter)
        
        } else if let cell = expandableTableView.cellForRow(at: indexPath) as? JFCheckBoxCustomCell {
            filter.updateValue(type: cell.currentFilter)
        }

        expandableTableView.beginUpdates()
        expandableTableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
        expandableTableView.endUpdates()
        updateViewStateWithFilterSettings()
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, expandedCell: UITableViewCell, didSelectExpandedRowAt indexPath: IndexPath) {
        print("didSelectExpandedRowAt:\(indexPath)")
        if let cell = expandedCell as? JFCheckBoxCustomCell {
            print("Current filter is: \(cell.currentFilter)")
            
            filter.updateValue(type: cell.currentFilter)
            
            refineTableView.reloadData()
            updateViewStateWithFilterSettings()
        }
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = expandableTableView.dequeueReusableCell(withIdentifier: "JFHeaderCustomCell") as! JFHeaderCustomCell
        cell.headerLabel.text = section == 0 ? "Filter" : ""
        return cell
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 50 : 16
    }
    
    func expandableTableView(_ expandableTableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

//MARK:- JFCheckBoxCustomCellDelegate
extension JFRefineResultsViewController: JFCheckBoxCustomCellDelegate {
    
    func locationValueChange(location: SelectedLocation) {
        filter.distance = location
        let indexPath = IndexPath(item: 0, section: 0)
        guard let cell = refineTableView.cellForRow(at: indexPath) as? JFExpandableCustomCell else {return}
        cell.titleLabel.text = filter.distance == .miNone ? "Location" : "Location (\(filter.distance.rawValue) mi)"
        updateViewStateWithFilterSettings()
    }
    
    func checkBoxTapped(JFLocationCustomCell cell: JFLocationCustomCell) {

        if cell.hasLocationAccess {
            cell.hasLocationAccess = false
            filter.distance = .miNone
            
        } else {
            locationCell = cell
            
            if CLLocationManager.locationServicesEnabled() {
                locationAccess()
                
            } else {
                UIAlertController.showAlert(inViewController: self, title: "Hackfest-swvl", message: "Location services are disabled, you can enable location services from Setting", okButtonTitle: "Settings", cancelButtonTitle: "Not now") { [weak self] (success) in
                    
                    if success {
                        guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                            return
                        }
                        
                        if UIApplication.shared.canOpenURL(settingsUrl) {
                            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                                print("Settings opened: \(success)") // Prints true
                                self?.locationManager.delegate = nil
                            })
                        }
                        
                    } else {
                        // Do nothing for now
                    }
                }
            }
        }
        
        updateViewStateWithFilterSettings()
    }
}

//MARK:- CLLocationManagerDelegate
extension JFRefineResultsViewController: CLLocationManagerDelegate {
    func locationAccess() {
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined, .restricted:
            print("No access yet")
            
        case .denied:
            print("Don't allow")
            
            UIAlertController.showAlert(inViewController: self, title: "Hackfest-swvl", message: "Location services permission not allowed, you can change permission from Setting", okButtonTitle: "Settings", cancelButtonTitle: "Not now") { (success) in
                
                if success {
                    guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                        return
                    }
                    
                    if UIApplication.shared.canOpenURL(settingsUrl) {
                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                            print("Settings opened: \(success)") // Prints true
                        })
                    }
                    
                } else {
                    // Do nothing for now
                }
            }
            
        case .authorizedAlways, .authorizedWhenInUse:
            print("Allow")
            locationCell?.hasLocationAccess = true
            filter.distance = .mi25
            updateViewStateWithFilterSettings()
        }
    }
}
