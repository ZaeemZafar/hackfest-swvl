////
////  InfoDataSource.swift
////  Hackfest-swvl
////
////  Created by zaktech on 4/26/18.
////  Copyright © 2018 maskers. All rights reserved.
////
//
//import Foundation
//
//
//
//class InfoDataSource: NSObject {
//    
//    // Implement this block to comunicate information related to didSelectRow event
//    var rowDidSelected: ((IndexPath) -> ())?
//    
//    var profileButtonTappedClosure: (() -> ())?
//    
//    init(info: ProfileInfo) {
//        self.info = info
//        
//        super.init()
//    }
//    
//    @objc func editProfileTapped() {
//        self.profileButtonTappedClosure?()
//    }
//    
//    func 
//}
//
//extension InfoDataSource: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return MyProfileTableDataSourceEnum.rowCount
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        
//        
//        
//        if indexPath.row == 0 {
//            
//            let cell = tableView.dequeueReusableCell(withIdentifier: "JFProfileInfoCustomCell") as! JFProfileInfoCustomCell
//            
//            cell.startActivityIndicatior()
//            
//            if let imageURL = URL(string: JFConstants.s3ImageURL + info.imagePath) {
//                cell.profileImage.af_setImage(
//                    withURL:  imageURL,
//                    placeholderImage: #imageLiteral(resourceName: "profile_icon_placeholder"),
//                    filter: nil,
//                    imageTransition: UIImageView.ImageTransition.crossDissolve(0.3),
//                    runImageTransitionIfCached: false) {
//                        // Completion closure
//                        response in
//                        // Check if the image isn't already cached
//                        if response.response != nil {
//                            
//                        }
//                        
//                        if let retrievedImage = response.result.value {
//                            self.info.image = retrievedImage
//                            retrievedImage.printSize()
//                        }
//                        cell.stopActivityIndicatior()
//                }
//            }
//            
//            cell.givenLbl = "\(info.given)"
//            cell.receivedLbl = "\(info.received)"
//            cell.nameLbl = info.firstName + " " + info.lastName
//            cell.facebookImg = info.displayFBProfileLink
//            cell.userFbID = info.facebookID
//            cell.locationLbl = info.location
//            cell.bioLbl = info.bio
//            
//            cell.editProfileButton.addTarget(self, action: #selector(editProfileTapped), for: .touchUpInside)
//            
//            return cell
//            
//        } else if indexPath.row == 1 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "JFGraphCustomCell") as! JFGraphCustomCell
//            
//            cell.configure(with: info, types: selectedGraphs)
//            
//            return cell
//            
//        } else {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "JFCategoryCustomCell") as! JFCategoryCustomCell
//                        
//            if indexPath.row == 2 {
//                cell.catIcon = #imageLiteral(resourceName: "appearance_icon_yellow")
//                cell.catTitle = "Appearance"
//                cell.catIndex = info.indexMultiplier(forType: .appearance)?
//                cell.catPercentage = info.indexMultiplier(forType: .appearance)?.rateOFChangeString
//                
//            } else if indexPath.row == 3 {
//                cell.catIcon = #imageLiteral(resourceName: "personality_icon_lightred")
//                cell.catTitle = "Personality"
//                cell.catIndex = info.indexMultiplier(forType: .personality)?.indexValue
//                cell.catPercentage = info.indexMultiplier(forType: .personality)?.rateOFChangeString
//                
//            } else if indexPath.row == 4 {
//                cell.catIcon = #imageLiteral(resourceName: "intelligence_bulb_icon_lightblue")
//                cell.catTitle = "Intelligence"
//                cell.catIndex = info.indexMultiplier(forType: .intelligence)?.indexValue
//                cell.catPercentage = info.indexMultiplier(forType: .intelligence)?.rateOFChangeString
//            }
//            
//            return cell
//        }
//    }
//}
//
//extension InfoDataSource: UITableViewDelegate {
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        
//        guard let cell = tableView.cellForRow(at: indexPath) as? JFCategoryCustomCell else { return }
//        
//        if cell.isCellSelected {
//            cell.containerView.layer.borderWidth = 0
//            
//            if indexPath.row == 2 {
//                cell.isCellSelected = !cell.isCellSelected
//                selectedGraphs.setGraphType(graphType: .appearance)
//                
//            } else if indexPath.row == 3 {
//                cell.isCellSelected = !cell.isCellSelected
//                selectedGraphs.setGraphType(graphType: .personality)
//
//            } else if indexPath.row == 4 {
//                cell.isCellSelected = !cell.isCellSelected
//                selectedGraphs.setGraphType(graphType: .intelligence)
//            }
//            
//        } else {
//            cell.containerView.layer.borderWidth = 2
//            
//            if indexPath.row == 2 {
//                cell.containerView.layer.borderColor = UIColor.jfCategoryOrange.cgColor
//                cell.isCellSelected = !cell.isCellSelected
////                NotificationCenter.default.post(name: .appearance, object: nil)
//                selectedGraphs.setGraphType(graphType: .appearance)
//                
//                
//            } else if indexPath.row == 3 {
//                cell.containerView.layer.borderColor = UIColor.jfCategoryRed.cgColor
//                cell.isCellSelected = !cell.isCellSelected
////                NotificationCenter.default.post(name: .personality, object: nil)
//                selectedGraphs.setGraphType(graphType: .personality)
//                
//            } else if indexPath.row == 4 {
//                cell.containerView.layer.borderColor = UIColor.jfCategoryBlue.cgColor
//                cell.isCellSelected = !cell.isCellSelected
////                NotificationCenter.default.post(name: .intelligence, object: nil)
//                selectedGraphs.setGraphType(graphType: .intelligence)
//            }
//        }
//        
//        if let graphcell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? JFGraphCustomCell {
//            graphcell.configure(with: info, types: selectedGraphs)
//        }
//    }
//
//}

