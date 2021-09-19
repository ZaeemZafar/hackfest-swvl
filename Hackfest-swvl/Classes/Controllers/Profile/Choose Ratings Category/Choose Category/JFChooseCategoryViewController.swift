//
//  JFChooseCategoryViewController.swift
//  Hackfest-swvl
//
//  Created by zaktech on 5/23/18.
//  Copyright © 2018 maskers. All rights reserved.
//

import UIKit

enum JFChooseCategoryRows: Int, CaseIterable {
    case friendly = 0, dressing, iqLevel, communication, personality, behavior, cleanliness, punctuality, appearance
}

class JFChooseCategoryViewController: JFViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var categoryTableView: UITableView!
    @IBOutlet weak var nextButton: JFButton!
    @IBOutlet weak var submitRatingButtonContainer: UIView!
    
    //MARK:- Public properties
    lazy var ratings = [CategoryTypes: [Int]]()
    var ratedUser: JFProfile!
    var ratingAgain = false
    var hasUpdatedRating = false
    var dataSourceArray = [CategoryTypes]()
    
    //MARK:- UIViewController lifecycle
    deinit {
        print("Deinit called for choose category vc :)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ratings = ratedUser.ratings
        setupDataSourceArrayAndRatings()
        categoryTableView.register(identifiers: [JFChooseCategoryCustumCell.self])

        categoryTableView.delegate = self
        categoryTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setupNavigation()
        
        setupDataSourceArrayAndRatings()
        
        self.categoryTableView.reloadData()
        
        let hasNoRating = ratings.filter({$0.value.count > 0}).first == nil ? true : false
        
        if ratingAgain {
            nextButton.addSpacingWithTitle(title: "RATE AGAIN")
            submitRatingButtonContainer.isHidden = hasNoRating || !hasUpdatedRating
            
        } else {
            nextButton.addSpacingWithTitle(title: "SUBMIT RATING")
            submitRatingButtonContainer.isHidden = hasNoRating
        }
    }
    
    //MARK:- User actions
    @IBAction func submitRatingTapped(_ sender: JFButton) {
        let vc = getShowNameOrAnonymousVC()
        vc.ratedUser = self.ratedUser
        vc.ratings = ratings
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK:- Helper methods
    func setupNavigation() {
        self.navigationItem.title = "CHOOSE CATEGORY"
        
        let leftButtomItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonTapped))
        leftButtomItem.tintColor = UIColor.jfDarkGray
        customLeftButton(button: leftButtomItem)
    }
    
    func setupDataSourceArrayAndRatings() {
        dataSourceArray.removeAll()
        
        Trait.allCases.forEach { trait in
            if case .none = trait {
                print("None")
            } else {
//                if ratedUser.trait[trait] == true {
                    dataSourceArray.append(trait.categoryType)
//                } else {
//                    ratings.removeValue(forKey: trait.categoryType)
//                }
            }
            
        }
    }
    
    @objc func cancelButtonTapped() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
}

//MARK:- UITableViewDataSource
extension JFChooseCategoryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataSourceArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JFChooseCategoryCustumCell") as! JFChooseCategoryCustumCell
        
        let categoryItem = dataSourceArray[indexPath.row]
        
        cell.title = categoryItem.name.uppercased()
        cell.categoryTitleLabel.textColor = categoryItem.titleColor
        cell.words = categoryItem.indexToWords(selectedIndexes: ratings[categoryItem]!) // TODO: Need to check !
        
        return cell
    }
}

//MARK:- UITableViewDelegate
extension JFChooseCategoryViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = getRatingCategoryChooseWordsVC()
        
        let selectedCategory = dataSourceArray[indexPath.row]
        vc.selectedCategory = selectedCategory
        vc.ratings = ratings
        vc.userName = ratedUser.fullName + "'s "
        
        vc.ratingsUpdated = { [weak self] updatedRatingValue in
            self?.ratings = updatedRatingValue
            self?.hasUpdatedRating = true
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ((self.categoryTableView.bounds.size.height) - (self.navigationController?.navigationBar.frame.height ?? 0))  / 3.0
    }
}
