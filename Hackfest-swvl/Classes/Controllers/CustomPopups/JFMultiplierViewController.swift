//
//  JFMultiplierViewController.swift
//  Hackfest-swvl
//
//  Created by zaktech on 8/29/18.
//  Copyright © 2018 Citrusbits. All rights reserved.
//

import UIKit

class JFMultiplierInfo {
    var jfim: Double
    var jfIndex: Double
    var multiplier: Double
    var jfiPercentage: Double
    var percentCurrentValue: Double
    var percentPreviousValue: Double
    
    var categoriesAppearance: Double
    var categoriesAppearancePercentage: Double
    var categoriesAppearancePercentageCurrentValue: Double
    var categoriesAppearancePercentagePreviousValue: Double
    
    var categoryPersonality: Double
    var categoriesPersonalityPercentage: Double
    var categoriesPersonalityPercentageCurrentValue: Double
    var categoriesPersonalityPercentagePreviousValue: Double
    
    var categoryIntelligence: Double
    var categoriesIntelligencePercentage: Double
    var categoriesIntelligencePercentageCurrentValue: Double
    var categoriesIntelligencePercentagePreviousValue: Double
    
    init(jfim: Double, jfIndex: Double, multiplier: Double, jfiPercentage: Double, percentCurrentValue: Double, percentPreviousValue: Double, categoriesAppearance: Double, categoriesAppearancePercentage: Double, categoriesAppearancePercentageCurrentValue: Double, categoriesAppearancePercentagePreviousValue: Double, categoryPersonality: Double, categoriesPersonalityPercentage: Double, categoriesPersonalityPercentageCurrentValue: Double, categoriesPersonalityPercentagePreviousValue: Double, categoryIntelligence: Double, categoriesIntelligencePercentage: Double, categoriesIntelligencePercentageCurrentValue: Double, categoriesIntelligencePercentagePreviousValue: Double) {
        
        self.jfim = jfim
        self.jfIndex = jfIndex
        self.multiplier = multiplier
        self.jfiPercentage = jfiPercentage
        self.percentCurrentValue = percentCurrentValue
        self.percentPreviousValue = percentPreviousValue
        
        self.categoriesAppearance = categoriesAppearance
        self.categoriesAppearancePercentage = categoriesAppearancePercentage
        self.categoriesAppearancePercentageCurrentValue = categoriesAppearancePercentageCurrentValue
        self.categoriesAppearancePercentagePreviousValue = categoriesAppearancePercentagePreviousValue
        
        self.categoryPersonality = categoryPersonality
        self.categoriesPersonalityPercentage = categoriesPersonalityPercentage
        self.categoriesPersonalityPercentageCurrentValue = categoriesPersonalityPercentageCurrentValue
        self.categoriesPersonalityPercentagePreviousValue = categoriesPersonalityPercentagePreviousValue
        
        self.categoryIntelligence = categoryIntelligence
        self.categoriesIntelligencePercentage = categoriesIntelligencePercentage
        self.categoriesIntelligencePercentageCurrentValue = categoriesIntelligencePercentageCurrentValue
        self.categoriesIntelligencePercentagePreviousValue = categoriesIntelligencePercentagePreviousValue
    }
    
    init() {
        
        self.jfim = 0.0
        self.jfIndex = 0.0
        self.multiplier = 0.0
        self.jfiPercentage = 0.0
        self.percentCurrentValue = 0.0
        self.percentPreviousValue = 0.0
        
        self.categoriesAppearance = 0.0
        self.categoriesAppearancePercentage = 0.0
        self.categoriesAppearancePercentageCurrentValue = 0.0
        self.categoriesAppearancePercentagePreviousValue = 0.0
        
        self.categoryPersonality = 0.0
        self.categoriesPersonalityPercentage = 0.0
        self.categoriesPersonalityPercentageCurrentValue = 0.0
        self.categoriesPersonalityPercentagePreviousValue = 0.0
        
        self.categoryIntelligence = 0.0
        self.categoriesIntelligencePercentage = 0.0
        self.categoriesIntelligencePercentageCurrentValue = 0.0
        self.categoriesIntelligencePercentagePreviousValue = 0.0
    }
    
    convenience init(indexRawData: JfIndexRawInformation, earlyData: EarlyValue, calculationData: Calculation) {
        self.init()
        
        self.jfim = 0.0
        self.jfIndex = calculationData.jfIndex ?? 0
        self.multiplier = calculationData.jfMultiplier ?? 0
        self.jfiPercentage = calculationData.rateOfChange ?? 0
        self.percentCurrentValue = calculationData.jFIM ?? 0
        self.percentPreviousValue = (earlyData.jfIndex ?? 0) * (earlyData.jfMultiplier ?? 0)
        
        self.categoriesAppearance = 0.0
        self.categoriesAppearancePercentage = calculationData.appearanceRateOfChange ?? 0
        self.categoriesAppearancePercentageCurrentValue = indexRawData.traitAppearanceAverage ?? 0
        self.categoriesAppearancePercentagePreviousValue = earlyData.appearanceAverage ?? 0
        
        self.categoryPersonality = 0.0
        self.categoriesPersonalityPercentage = calculationData.personalityRateOfChange ?? 0
        self.categoriesPersonalityPercentageCurrentValue = indexRawData.traitPersonalityAverage ?? 0
        self.categoriesPersonalityPercentagePreviousValue = earlyData.personalityAverage ?? 0
        
        self.categoryIntelligence = 0.0
        self.categoriesIntelligencePercentage = calculationData.intelligenceRateOfChange ?? 0
        self.categoriesIntelligencePercentageCurrentValue = indexRawData.traitIntelligenceAverage ?? 0
        self.categoriesIntelligencePercentagePreviousValue = earlyData.intelligenceAverage ?? 0
    }
    
    func getValueForDataType(type: MultiplierData) -> Double {
        switch type {
        
        case .jfim: return jfim
        case .jfIndex: return jfIndex
        case .multiplier: return multiplier
        case .jfiPercentage: return jfiPercentage
        case .percentCurrentValue: return percentCurrentValue
        case .percentPreviousValue: return percentPreviousValue
            
        case .categoriesAppearance: return categoriesAppearance
        case .categoriesAppearancePercentage: return categoriesAppearancePercentage
        case .categoriesAppearancePercentageCurrentValue: return categoriesAppearancePercentageCurrentValue
        case .categoriesAppearancePercentagePreviousValue: return categoriesAppearancePercentagePreviousValue
            
        case .categoryPersonality: return categoryPersonality
        case .categoriesPersonalityPercentage: return categoriesPersonalityPercentage
        case .categoriesPersonalityPercentageCurrentValue: return categoriesPersonalityPercentageCurrentValue
        case .categoriesPersonalityPercentagePreviousValue: return categoriesPersonalityPercentagePreviousValue
            
        case .categoryIntelligence: return categoryIntelligence
        case .categoriesIntelligencePercentage: return categoriesIntelligencePercentage
        case .categoriesIntelligencePercentageCurrentValue: return categoriesIntelligencePercentageCurrentValue
        case .categoriesIntelligencePercentagePreviousValue: return categoriesIntelligencePercentagePreviousValue
        default:
            return 0.0
        }
    }
}

enum MultiplierData: Int {
    case jfim = 0, jfIndex, multiplier, jfiPercentage, percentCurrentValue, percentPreviousValue, categoriesAppearance, categoriesAppearancePercentage, categoriesAppearancePercentageCurrentValue, categoriesAppearancePercentagePreviousValue, categoryPersonality, categoriesPersonalityPercentage, categoriesPersonalityPercentageCurrentValue, categoriesPersonalityPercentagePreviousValue, categoryIntelligence, categoriesIntelligencePercentage, categoriesIntelligencePercentageCurrentValue, categoriesIntelligencePercentagePreviousValue, count
    
    var titleTextString: String {
        switch self {
        case .jfim: return "JF-Index"
        case .jfIndex: return "JF-Index: "
        case .multiplier: return "Multiplier: "
        case .jfiPercentage: return "JFIM %: "
        case .percentCurrentValue: return "JFIM Current value: "
        case .percentPreviousValue: return "JFIM Previous value (24h): "
            
        case .categoriesAppearance: return "Appearance"
        case .categoriesAppearancePercentage: return "Percentage: "
        case .categoriesAppearancePercentageCurrentValue: return "Current value: "
        case .categoriesAppearancePercentagePreviousValue: return "Previous value (24h): "
            
        case .categoryPersonality: return "Personality"
        case .categoriesPersonalityPercentage: return "Percentage: "
        case .categoriesPersonalityPercentageCurrentValue: return "Current value: "
        case .categoriesPersonalityPercentagePreviousValue: return "Previous value (24h): "
            
        case .categoryIntelligence: return "Intelligence"
        case .categoriesIntelligencePercentage: return "Percentage: "
        case .categoriesIntelligencePercentageCurrentValue: return "Current value: "
        case .categoriesIntelligencePercentagePreviousValue: return "Previous value (24h): "
            
        default:
            return ""
        }
    }
    
    func headingTitles() -> Bool {
        switch self {
        case .jfim, .categoriesAppearance, .categoryPersonality, .categoryIntelligence:
            return true
        default:
            return false
        }
    }
}

class JFMultiplierViewController: JFViewController {

    //MARK:- IBOutlets
    @IBOutlet weak var multiplierTableView: UITableView!
    
    //MARK:- Public properties
    var multiplierInfo = JFMultiplierInfo()
    
    
    //MARK:- UIViewController lifecycle
    deinit {
        print("Deinit called for Multiplier Dubug vc :)")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getIndexDetail()
        setupNavigation()
        multiplierTableView.delegate = self
        multiplierTableView.dataSource = self
    }
    
    //MARK:- User actions
    @IBAction func dimissButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    //MARK:- Helper methods
    func setupNavigation() {
        setNavTitle(title: "JFI Calculation Data")
        addBackButton()
    }
}

extension JFMultiplierViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MultiplierData.count.rawValue
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let multiplierCell = tableView.dequeueReusableCell(withIdentifier: "JFMultiplierTableViewCell") as! JFMultiplierTableViewCell
        
        if let aMultiplierData = MultiplierData(rawValue: indexPath.row) {
            multiplierCell.titleLabel.text = aMultiplierData.titleTextString
            
            if aMultiplierData.headingTitles() {
                multiplierCell.backgroundColor = UIColor.appBackGroundColor
                multiplierCell.titleLabel.font = UIFont.medium(fontSize: 17.0)
            } else {
                multiplierCell.backgroundColor = UIColor.clear
                multiplierCell.titleLabel.font = UIFont.light(fontSize: 17.0)
            }
            multiplierCell.detailLabel.isHidden = aMultiplierData.headingTitles()
            multiplierCell.detailLabel.text = String(multiplierInfo.getValueForDataType(type: aMultiplierData))
        }
        
        return multiplierCell
    }
}

//MARK:- Network calls
extension JFMultiplierViewController {
    
    func getIndexDetail() {
        let endPoint = JFUserEndpoint.indexDetail
        
        MBProgressHUD.showCustomHUDAddedTo(view: self.tabBarController?.view, title: JFLoadingTitles.loadingProfile, animated: true)
        
        JFWSAPIManager.shared.sendJFAPIRequest(apiConfig: endPoint) { [weak self] (response: JFWepAPIResponse<IndexMultiplierApiBase>) in
            guard let strongSelf = self else { return }
            
            MBProgressHUD.hides(for: strongSelf.tabBarController?.view, animated: true)
            
            guard let indexRawData = response.data?.jfIndexRawInformation else { return }
            guard let earlyData = response.data?.earlyValue else { return }
            guard let calculationData = response.data?.calculation else { return }
            
            strongSelf.multiplierInfo = JFMultiplierInfo(indexRawData: indexRawData, earlyData: earlyData, calculationData: calculationData)
            
            strongSelf.multiplierTableView.reloadData()
        }
    }
}

extension JFMultiplierViewController: UINavigationBarDelegate {
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}
