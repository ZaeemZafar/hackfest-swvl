//
//  JFChooseCategoryWordsViewController.swift
//  Hackfest-swvl
//
//  Created by zaktech on 5/24/18.
//  Copyright © 2018 maskers. All rights reserved.
//

import UIKit

enum CategoryTypes: Int, Codable, CaseIterable {
    case friendly = 0, dressing, iqLevel, communication, personality, behavior, cleanliness, punctuality, appearance
}

//MARK:- CategoryTypes
extension CategoryTypes {
    var wordsArray: [String] {
        get {
            return ["bad", "average", "good", "excellent"]
        }
    }
    
    var name: String {
        switch self {
        case .friendly: return "friendly"
        case .dressing: return "dressing"
        case .iqLevel: return "iqLevel"
        case .communication: return "communication"
        case .personality: return "personality"
        case .behavior: return "behavior"
        case .cleanliness: return "cleanliness"
        case .punctuality: return "punctuality"
        case .appearance: return "appearance"
        }
    }
    
    var titleColor: UIColor {
        switch self {
        case .appearance: return UIColor.jfCategoryOrange
        case .personality: return UIColor.jfCategoryRed
        default: return UIColor.red
        }
    }
    
    func indexToWords(selectedIndexes: [Int]) -> String {
        var words = [String]()
        
        for index in selectedIndexes.reversed() {
            let indexOfWordsArray = JFCategoryWords.wordsScoreAtIndex.index(of: index) ?? 0
            
            words.append(wordsArray[indexOfWordsArray])
        }
        
        return words.joined(separator: ", ")
    }
}

class JFChooseCategoryWordsViewController: JFViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var wordsCollectionView: UICollectionView!
    @IBOutlet weak var nextButtonContainer: UIView!
    @IBOutlet weak var nextButton: JFButton!

    //MARK:- Public properties
    var editingRating = false
    var selectedCategory: CategoryTypes!
    lazy var ratings = [CategoryTypes: [Int]]()
    var ratingsUpdated: (([CategoryTypes: [Int]]) -> Void)?
    var userName = ""
    
    //MARK:- UIViewController lifecycle
    deinit {
        print("Deinit called for choose category words vc :)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        wordsCollectionView.allowsSelection = true
        wordsCollectionView.allowsMultipleSelection = true
        wordsCollectionView.contentInset = UIEdgeInsetsMake(0, 8, 16, 8)
        automaticallyAdjustsScrollViewInsets = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setupNavigation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        updateView()
    }
    
    //MARK:- User actions
    @IBAction func nextButtonTapped(_ sender: JFButton) {
        self.ratingsUpdated?(ratings)
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- Helper methods
    func updateView() {
        ratings[selectedCategory] = ratings[selectedCategory]!.sorted()
        self.navigationItem.title = ratings[selectedCategory]!.isEmpty ? selectedCategory.name.uppercased() : "\(selectedCategory.name.uppercased()) (\(ratings[selectedCategory]!.count))"
    }
    
    func setupNavigation() {
        self.navigationItem.title = ratings[selectedCategory]!.isEmpty ? selectedCategory.name.uppercased() : "\(selectedCategory.name.uppercased()) (\(ratings[selectedCategory]!.count))"
        addBackButton()
    }
}

//MARK:- UICollectionViewDataSource
extension JFChooseCategoryWordsViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return JFCategoryWords.wordsScoreAtIndex.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let ratingValue = JFCategoryWords.wordsScoreAtIndex[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JFCategoryWordsCustomCell", for: indexPath) as! JFCategoryWordsCustomCell
        
        cell.configureCellWithData(indexPath: indexPath, ratingValue: ratingValue, selectedIndexs: ratings[selectedCategory]!, wordsArray: selectedCategory.wordsArray)
        
        return cell
    }
}

//MARK:- UICollectionViewDelegate
extension JFChooseCategoryWordsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let ratingValue = JFCategoryWords.wordsScoreAtIndex[indexPath.row]
        print("Selected Cateogory score is \(ratingValue)")
        
        if ratings[selectedCategory]!.contains(ratingValue) {
            ratings[selectedCategory]!.remove(at: ratings[selectedCategory]!.index(of: ratingValue)!)
            
        } else if ratings[selectedCategory]!.count <= 2 {
            ratings[selectedCategory]!.append(ratingValue)
        }
        
        updateView()
        
        if let cell = collectionView.cellForItem(at: indexPath) {
            print(cell.bounds)
            collectionView.scrollToItem(at: indexPath, at: [.bottom], animated: true)
        }
        
        wordsCollectionView.reloadItems(at: [indexPath])
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "JFHeaderCollectionReusableView", for: indexPath) as! JFHeaderCollectionReusableView
        
        headerView.titleLabel.text = selectedCategory.name.uppercased()
        headerView.titleLabel.textColor = selectedCategory.titleColor

        let formattedString = NSMutableAttributedString()
        formattedString
            .normal("Select up to 3 words that describe \n")
            //.bold("Jamia Levan's ")
            .bold(userName)
            .normal("\(selectedCategory.name).")
        headerView.descriptionLabel.attributedText = formattedString
        
        return headerView
    }
}

//MARK:- UICollectionViewDelegateFlowLayout
extension JFChooseCategoryWordsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellWidth = (collectionView.bounds.width - 32) / 3.0
        let cellHeight = cellWidth * 0.7281
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
}
