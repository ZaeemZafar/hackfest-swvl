//
//  JFRatingsHistoryViewController.swift
//  Hackfest-swvl
//
//  Created by zaktech on 9/6/18.
//  Copyright © 2018 maskers. All rights reserved.
//

import UIKit

class JFRatingsHistoryViewController: JFViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var ratingsHistoryTableView: UITableView!
    var ratingHistoryData = [RatingsHistoryData]()
    
    //MARK:- Public properties
    
    //MARK:- UIViewController lifecycle
    deinit {
        print("Deinit called for Multiplier Dubug vc :)")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getRatingsHistory()
        setupNavigation()
        
        ratingsHistoryTableView.delegate = self
        ratingsHistoryTableView.dataSource = self
        
        ratingsHistoryTableView.tableFooterView = UIView()
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

extension JFRatingsHistoryViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ratingHistoryData.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ratingHistoryCell = tableView.dequeueReusableCell(withIdentifier: "JFRatingsHistoryTableViewCell") as! JFRatingsHistoryTableViewCell
        
        let rowData = ratingHistoryData[indexPath.row]
        ratingHistoryCell.configureCell(data: rowData)
        
        return ratingHistoryCell
    }
}

//MARK:- Network calls
extension JFRatingsHistoryViewController {
    
    func getRatingsHistory() {
        let endPoint = JFUserEndpoint.ratingsHistory
        
        MBProgressHUD.showCustomHUDAddedTo(view: self.tabBarController?.view, title: JFLoadingTitles.loadingProfile, animated: true)
        
        JFWSAPIManager.shared.sendJFAPIRequest(apiConfig: endPoint) { [weak self] (response: JFWepAPIResponse<RatingsHistoryAPIBase>) in
            guard let strongSelf = self else { return }
            
            MBProgressHUD.hides(for: strongSelf.tabBarController?.view, animated: true)
            
            guard let ratingHistoryData = response.data?.ratingData else { return }
            
            strongSelf.ratingHistoryData = ratingHistoryData.sorted(by: { (dataA, dataB) -> Bool in
                dataA.updatedDate.compare(dataB.updatedDate) == .orderedDescending
            })
            
            strongSelf.ratingsHistoryTableView.reloadData()
        }
    }
}

extension JFRatingsHistoryViewController: UINavigationBarDelegate {
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}
