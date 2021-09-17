//
//  JFEditProfileViewController.swift
//  Hackfest-swvl
//
//  Created by zaktech on 4/29/18.
//  Copyright © 2018 Citrusbits. All rights reserved.
//

import UIKit
import AVFoundation

enum NavigationTo {
    case changePasswrod
    case changeEmail
    case changePhoneNumber
}

private enum JFEditProfileSections: Int {
    case profilePhoto = 0
    case personalInformation
    case privateInformation
    case count
}

private enum JFEditProfileProfileImageRows: Int {
    case profileImage = 0
    case count
}

private enum JFEditProfilePersonalInfoRows: Int {
    case fullName = 0
    case location
    case biography
    case count
}

private enum JFEditProfilePrivateInfoRows: Int {
    case password = 0
    case email
    case phoneNumber
    case count
}

private enum JFEditProfileEmptyRows: Int {
    case empty = 0
    case count
}

class JFEditProfileViewController: JFViewController, KeyboardProtocol {
    
    //MARK:- IBOutlets
    @IBOutlet weak var editProfileTableView: UITableView!
    @IBOutlet weak var tableViewBottomContraint: NSLayoutConstraint!
    
    //MARK:- Public properties
    var imagePickerInProgress = false
    var alert = UIAlertController()
    var userInfo = ProfileInfo()
    var isEditingEnable = false
    var jfFirstNameTextField = UITextField()
    var jfLastNameTextField = UITextField()
    var jfLocationTextView = UITextView()
    var jfBiographyTextView = UITextView()
    var jfLocationChanged = false
    var jfBiographyChanged = false
    var privateRowsArray: [Int] = [JFEditProfilePrivateInfoRows.password.rawValue,
                                   JFEditProfilePrivateInfoRows.email.rawValue,
                                   JFEditProfilePrivateInfoRows.phoneNumber.rawValue]
    var isFacebookUser = 0
    
    //MARK:- UIViewController lifecycle
    deinit {
        print("Deinit called for edit profile vc :)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addKeyboardShowObserver { [weak self] height in
            self?.tableViewBottomContraint.constant = height - 50
        }
        addKeyboardHideObserver { [weak self] in
            self?.tableViewBottomContraint.constant = 0
        }
        
        if userInfo.isFacebookUser {
            isFacebookUser = 2
        } else {
            isFacebookUser = 0
        }
        
        setupNavigation()
        
        editProfileTableView.register(identifiers: [JFProfileImageCustomCell.self, JFPersonalInfoTwoTextFieldCustomCell.self, JFPersonalInfoTextFieldCustomCell.self, JFPersonalInfoTextViewCustomCell.self, JFPrivateInfoLabelCustomCell.self, JFHeaderCustomCell.self, JFFooterCustomCell.self])
        
        editProfileTableView.estimatedRowHeight = 70
        editProfileTableView.rowHeight = UITableViewAutomaticDimension
        editProfileTableView.delegate = self
        editProfileTableView.dataSource = self
        editProfileTableView.tableFooterView = UIView()
        
        registerNotificationObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        print("Phone number is: \(userInfo.phone)")
        if imagePickerInProgress == false {
            editProfileTableView.reloadData()
            
            // Update user profile with new API call
            self.getProfileData()
        }
    }
    
//    deinit {
//        print("Deinit called on\(String(describing: self))")
//    }
    
    //MARK:- Helper methods
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func setupNavigation() {
        self.navigationItem.title = JFLocalizableConstants.EditProfile
        
        let rightButtomItem = UIBarButtonItem(title: JFLocalizableConstants.SaveTitle, style: .plain, target: self, action: #selector(saveButtonTapped))
        rightButtomItem.tintColor = UIColor.jfDarkGray
        rightButtomItem.isEnabled = false
        customRightButton(button: rightButtomItem)
        
        let leftButtomItem = UIBarButtonItem(title: JFLocalizableConstants.CancelTitle, style: .plain, target: self, action: #selector(cancelButtonTapped))
        leftButtomItem.tintColor = UIColor.jfDarkGray
        customLeftButton(button: leftButtomItem)
    }
    
    @objc func saveButtonTapped() {
        view.endEditing(true)
        updateProfile()
    }
    
    @objc func cancelButtonTapped() {
        if (navigationItem.rightBarButtonItem?.isEnabled)! {
            
            UIAlertController.showAlert(inViewController: self, title: JFLocalizableConstants.ConfirmationTitle, message: JFLocalizableConstants.UnsavedChanges, okButtonTitle: JFLocalizableConstants.SaveTitle, cancelButtonTitle: JFLocalizableConstants.DiscardTitle) { [weak self] success in
                
                guard let strongSelf = self else { return }
                
                if success {
                    strongSelf.updateProfile()
                } else {
                    strongSelf.navigationController?.popViewController(animated: true)
                }
            }
            
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func navigate(to: NavigationTo) {
        
        switch to {
        case .changePasswrod:
            let vc = getChangePasswordVC()
            navigationController?.pushViewController(vc, animated: true)
            
        case .changeEmail:
            let vc = getChangeEmailVC()
            vc.profileInfo = self.userInfo
            navigationController?.pushViewController(vc, animated: true)
            
        case .changePhoneNumber:
            let vc = getChangePhoneVC()
            vc.userInfo = self.userInfo
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    @objc func emailUpdatedNotification(notification: Notification) {
        if JFSession.shared.isLogIn() {
            getProfileData()
        }
        
    }
    
    func setEditingEnable(editing: Bool) {
        isEditingEnable = editing
    }
    
    func registerNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(emailUpdatedNotification(notification:)), name: JFConstants.Notifications.emailUpdated, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(emailUpdatedNotification(notification:)), name: Notification.Name.UIApplicationDidBecomeActive, object: nil)
    }
    
    func unRegisterNotificationObservers() {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - UITextField Helper Methods
    func getFirstNameTextField() -> UITextField? {
        let indexPath = IndexPath(row: JFEditProfilePersonalInfoRows.fullName.rawValue, section: JFEditProfileSections.personalInformation.rawValue)
        let cell = self.editProfileTableView.cellForRow(at: indexPath) as! JFPersonalInfoTwoTextFieldCustomCell
        return cell.firstNameTextField
    }
    
    func getLastNameTextField() -> UITextField? {
        let indexPath = IndexPath(row: JFEditProfilePersonalInfoRows.fullName.rawValue, section: JFEditProfileSections.personalInformation.rawValue)
        let cell = self.editProfileTableView.cellForRow(at: indexPath) as! JFPersonalInfoTwoTextFieldCustomCell
        return cell.lastNameTextField
    }
    
    func getLocationTextView() -> UITextView? {
        let indexPath = IndexPath(row: JFEditProfilePersonalInfoRows.location.rawValue, section: JFEditProfileSections.personalInformation.rawValue)
        let cell = self.editProfileTableView.cellForRow(at: indexPath) as? JFPersonalInfoTextViewCustomCell
        return cell?.bioTextView
    }
    
    func getBiographyTextView() -> UITextView? {
        let indexPath = IndexPath(row: JFEditProfilePersonalInfoRows.biography.rawValue, section: JFEditProfileSections.personalInformation.rawValue)
        let cell = self.editProfileTableView.cellForRow(at: indexPath) as? JFPersonalInfoTextViewCustomCell
        return cell?.bioTextView
    }
}

//MARK:- UITableViewDataSource
extension JFEditProfileViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return JFEditProfileSections.count.rawValue
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case JFEditProfileSections.profilePhoto.rawValue:
            return JFEditProfileProfileImageRows.count.rawValue
        case JFEditProfileSections.personalInformation.rawValue:
            return JFEditProfilePersonalInfoRows.count.rawValue
        case JFEditProfileSections.privateInformation.rawValue:
            if isFacebookUser == 0 {
                return JFEditProfilePrivateInfoRows.count.rawValue
            }
            return 1
        default:
            return JFEditProfileEmptyRows.count.rawValue
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == JFEditProfileSections.profilePhoto.rawValue {
            let cell = tableView.dequeueReusableCell(withIdentifier: "JFProfileImageCustomCell") as! JFProfileImageCustomCell
            
            cell.imagePickerDelegate = self
            
            if userInfo.image != nil {
                cell.profileImageView.image = userInfo.image
                cell.profileImageView.contentMode = .scaleAspectFill
                
            } else {
                if let imageURL = URL(string: JFConstants.s3ImageURL  + userInfo.imagePath) {
                    cell.profileImageView.jf_setImage(withURL: imageURL, placeholderImage: #imageLiteral(resourceName: "profile_icon_placeholder"))
                    cell.profileImageView.contentMode = .scaleAspectFill
                }
            }
            
            return cell
            
        } else if indexPath.section == JFEditProfileSections.personalInformation.rawValue {
            if indexPath.row == JFEditProfilePersonalInfoRows.fullName.rawValue {
                let cell = tableView.dequeueReusableCell(withIdentifier: "JFPersonalInfoTwoTextFieldCustomCell") as! JFPersonalInfoTwoTextFieldCustomCell
                
                cell.userInfoTableViewCellDelegate = self
                cell.firstNameTitle.text = "First Name"
                cell.firstNameTextField.text = userInfo.firstName
                cell.lastNameTitle.text = "Last Name"
                cell.lastNameTextField.text = userInfo.lastName
                
                //cell.separatorInset = UIEdgeInsetsMake(0, cell.bounds.size.width, 0, 0)
                
                return cell
                
            } else if indexPath.row == JFEditProfilePersonalInfoRows.location.rawValue {
                let cell = tableView.dequeueReusableCell(withIdentifier: "JFPersonalInfoTextViewCustomCell") as! JFPersonalInfoTextViewCustomCell
                
                cell.userInfoTextViewCustomCellDelegate = self
                cell.titleLabel.text = "Location"
                cell.detailLabel = userInfo.location
                
                cell.bioTextView.tag = 1010
                
                return cell
                
            } else if indexPath.row == JFEditProfilePersonalInfoRows.biography.rawValue {
                let cell = tableView.dequeueReusableCell(withIdentifier: "JFPersonalInfoTextViewCustomCell") as! JFPersonalInfoTextViewCustomCell
                
                cell.userInfoTextViewCustomCellDelegate = self
                cell.titleLabel.text = "Biography"
                cell.detailLabel = userInfo.bio
                cell.bioTextView.tag = 1011
                
                return cell
                
            } else {
                return UITableViewCell()
            }
            
        } else if indexPath.section == JFEditProfileSections.privateInformation.rawValue {
            if indexPath.row == JFEditProfilePrivateInfoRows.password.rawValue - isFacebookUser {
                let cell = tableView.dequeueReusableCell(withIdentifier: "JFPrivateInfoLabelCustomCell") as! JFPrivateInfoLabelCustomCell
                
                cell.titleLabel.text = "Password"
                cell.subTitleLabel.text = "....................."
                
                return cell
                
            } else if indexPath.row == JFEditProfilePrivateInfoRows.email.rawValue - isFacebookUser {
                let cell = tableView.dequeueReusableCell(withIdentifier: "JFPrivateInfoLabelCustomCell") as! JFPrivateInfoLabelCustomCell
                
                cell.titleLabel.text = "Email"
                cell.subTitleLabel.text = userInfo.email
                
                return cell
                
            } else if indexPath.row == JFEditProfilePrivateInfoRows.phoneNumber.rawValue - isFacebookUser {
                let cell = tableView.dequeueReusableCell(withIdentifier: "JFPrivateInfoLabelCustomCell") as! JFPrivateInfoLabelCustomCell
                
                cell.titleLabel.text = "Phone Number"
                cell.subTitleLabel.text = userInfo.phone
                
                return cell
                
            } else {
                return UITableViewCell()
            }
            
        } else {
            return UITableViewCell()
        }
    }
}

//MARK:- UITableViewDelegate
extension JFEditProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == JFEditProfileSections.privateInformation.rawValue {
            switch indexPath.row {
            case JFEditProfilePrivateInfoRows.password.rawValue:
                if isFacebookUser == 0 {
                    navigate(to: .changePasswrod)
                } else {
                    navigate(to: .changePhoneNumber)
                }
            case JFEditProfilePrivateInfoRows.email.rawValue:
                navigate(to: .changeEmail)
            case JFEditProfilePrivateInfoRows.phoneNumber.rawValue:
                navigate(to: .changePhoneNumber)
            default:
                break
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JFHeaderCustomCell") as! JFHeaderCustomCell
        switch section {
        case JFEditProfileSections.personalInformation.rawValue:
            cell.headerLabel.text = "Personal Information"
            return cell.contentView
        case JFEditProfileSections.privateInformation.rawValue:
            cell.headerLabel.text = "Private Information"
            return cell.contentView
        default:
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case JFEditProfileSections.personalInformation.rawValue, JFEditProfileSections.privateInformation.rawValue:
            return 50.0
        default:
            return 0.0
        } 
    }
}

//MARK:- JFUserInfoTextViewCustomCellDelegate
extension JFEditProfileViewController: JFUserInfoTextViewCustomCellDelegate {
    
    func textViewDidBeginEditing(textView: UITextView) {
        if Devices.iPhone5AndSmallDevices && textView.tag == 1010 {
            UIView.setAnimationsEnabled(false) // Disable animations
            self.editProfileTableView.beginUpdates()
            self.editProfileTableView.endUpdates()
            
            let calcHeight = textView.sizeThatFits(textView.frame.size).height  //iOS 8+ only
            let scrollTo = calcHeight + 80
            
            self.editProfileTableView.setContentOffset(CGPoint(x: 0, y: scrollTo), animated: false)
            UIView.setAnimationsEnabled(true)  // Re-enable animations.
        }
        
        if textView.textColor == UIColor.jfLightGray {
            textView.text = ""
            textView.textColor = UIColor.jfDarkGray
        }
        
        print("TextView's text is: \(textView.text)")
        let endPosition: UITextPosition = textView.endOfDocument
        textView.selectedTextRange = textView.textRange(from: endPosition, to: endPosition)
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Tap here to edit..."
            textView.textColor = UIColor.jfLightGray
        }
    }
    
    func textChanged(textView: UITextView) {
        jfLocationTextView = getLocationTextView()!
        jfBiographyTextView = getBiographyTextView()!

        let startHeight = textView.frame.size.height
        let calcHeight = textView.sizeThatFits(textView.frame.size).height  //iOS 8+ only
        
        if startHeight != calcHeight {
            
            UIView.setAnimationsEnabled(false) // Disable animations
            self.editProfileTableView.beginUpdates()
            self.editProfileTableView.endUpdates()
            
            let scrollTo = calcHeight + 80

            self.editProfileTableView.setContentOffset(CGPoint(x: 0, y: scrollTo), animated: false)
            
            UIView.setAnimationsEnabled(true)  // Re-enable animations.
        }
        
        if (jfBiographyTextView.text != userInfo.bio) {
            jfBiographyChanged = true
        }
        if (jfLocationTextView.text != userInfo.location) {
            jfLocationChanged = true
        }
        
        if jfLocationChanged || jfBiographyChanged {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            
        } else {
            jfLocationChanged = false
            jfBiographyChanged = false
            self.navigationItem.rightBarButtonItem!.isEnabled = false
        }
    }
    
    func textView(textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        switch textView.tag {
        case 1010:
            return textView.text.count + (text.count - range.length) <= 150
        case 1011:
            return textView.text.count + (text.count - range.length) <= 250
        default:
            return textView.text.count + (text.count - range.length) <= 300
        }
    }
}

//MARK:- JFUserInfoTableViewCellDelegate
extension JFEditProfileViewController: JFUserInfoTableViewCellDelegate {
    func textFieldDidEndEditing(textField: UITextField) {
        
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    func textChanged(textfield: UITextField) {
        
        jfFirstNameTextField = getFirstNameTextField()!
        jfLastNameTextField = getLastNameTextField()!
        
        
        if (jfFirstNameTextField.text != userInfo.firstName) && jfFirstNameTextField.text!.count >= 2 && JFValidator.shared.isValidName(text: jfFirstNameTextField.text!) || (jfLastNameTextField.text != userInfo.lastName) && jfLastNameTextField.text!.count >= 2 && JFValidator.shared.isValidName(text: jfLastNameTextField.text!) {
            self.navigationItem.rightBarButtonItem!.isEnabled = true
        
        } else {
            self.navigationItem.rightBarButtonItem!.isEnabled = false
        }
    }
    
    func textField(textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return textField.text!.count + (string.count - range.length) <= 15
    }
}
//MARK:- ChangePhotoDelegate
extension JFEditProfileViewController: JFChangePhotoCustomCellDelegate {
    func pickImage() {
        ImagePickerHelper.shared.showAlert(on: self) { [weak self] image in
            self?.uploadImage(selectedImage: image)
        }
    }
}

//MARK:- Network calls
extension JFEditProfileViewController {
    func uploadImage(selectedImage: UIImage) {
        MBProgressHUD.showCustomHUDAddedTo(view: self.tabBarController?.view, title: JFLoadingTitles.uploadingPhoto, animated: true)
        
        JFServerManager.shared.uploadImage(imageFile: selectedImage, completion: { [weak self] (success, fileName, errorMessage) in
            guard let strongSelf = self else { return }
            
            if success {
                // Update profile image fileName
                JFWSAPIManager.shared.updateProfileImage(imageName: fileName, completion: { (success, errorMessage) in
                    MBProgressHUD.hides(for: strongSelf.tabBarController?.view, animated: false)
                    
                    MBProgressHUD.showConfirmationCustomHUDAddedTo(view: strongSelf.tabBarController?.view, title: "Profile Image Updated", image: #imageLiteral(resourceName: "rating_submitted_icon_grey"), animated: true)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                        MBProgressHUD.hides(for: strongSelf.tabBarController?.view, animated: true)
                        
                        strongSelf.imagePickerInProgress = false
                        strongSelf.userInfo.image = selectedImage
                        let indexPath = IndexPath(item: 0, section: 0)
                        strongSelf.editProfileTableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
                    })
                })
            } else {
                MBProgressHUD.hides(for: strongSelf.tabBarController?.view, animated: false)
                
                strongSelf.imagePickerInProgress = false
                let alertType = (errorMessage ?? "" == JFLocalizableConstants.NetworkError) ? AlertType.networkError : AlertType.defaultSystemAlert(message: errorMessage ?? "")
                
                JFAlertViewController.presentAlertController(with: alertType, fromViewController: strongSelf.tabBarController) { success in
                    if success {
                        //strongSelf.changePassword() stuck
                    }
                }
            }
        })
    }
    
    func updateProfile() {
        
        MBProgressHUD.showCustomHUDAddedTo(view: self.tabBarController?.view, title: JFLoadingTitles.updatingProfile, animated: true)
        
        let location = jfLocationChanged ? getLocationTextView()?.text : (getLocationTextView()?.text == "Tap here to edit...") ? "Tap here to edit..." : (userInfo.location != "") ? (userInfo.location) : ""
        let biography = jfBiographyChanged ? getBiographyTextView()?.text : (getBiographyTextView()?.text == "Tap here to edit...") ? "Tap here to edit..." : (userInfo.bio != "") ? (userInfo.bio) : ""
        
        JFWSAPIManager.shared.updateProfile(firstName: (getFirstNameTextField()?.text)!, lastName: (getLastNameTextField()?.text)!, location: location != "Tap here to edit..." ? location! : "" , bio: biography != "Tap here to edit..." ? biography! : "") {  [weak self] (success, errorMessage) in
            guard let strongSelf = self else { return }
            MBProgressHUD.hide(for: (strongSelf.tabBarController?.view)!, animated: true)
            
            if success {
                MBProgressHUD.showConfirmationCustomHUDAddedTo(view: (strongSelf.tabBarController?.view)!, title: "Saved", image: #imageLiteral(resourceName: "rating_submitted_icon_grey"), animated: true)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                    MBProgressHUD.hide(for: (strongSelf.tabBarController?.view)!, animated: true)
                    strongSelf.navigationController?.popViewController(animated: true)
                })
            } else {
                let alertType = (errorMessage ?? "" == JFLocalizableConstants.NetworkError) ? AlertType.networkError : AlertType.defaultSystemAlert(message: errorMessage ?? "")
                
                JFAlertViewController.presentAlertController(with: alertType, fromViewController: strongSelf.tabBarController) { success in
                    if success {
                        strongSelf.updateProfile()
                    }
                }
            }
        }
    }
    
    func getProfileData(showHud: Bool = false) {
        
        if showHud {
            MBProgressHUD.showCustomHUDAddedTo(view: self.tabBarController?.view, title: JFLoadingTitles.loadingProfile, animated: true)
        }
        
        JFWSAPIManager.shared.profile(graphRetrieved: nil, completion: {  [weak self] (success, profileInfo, errorMessage) in
            guard let strongSelf = self else { return }
            
            if showHud {
                MBProgressHUD.hide(for: (strongSelf.tabBarController?.view)!, animated: true)
            }
            
            if success {
                
                if let profileInfo = profileInfo {
                    strongSelf.userInfo.email = profileInfo.email
                    
                    if strongSelf.isFacebookUser == 0 {
                        let indexPath = IndexPath(row: JFEditProfilePrivateInfoRows.email.rawValue, section: 1)
                        strongSelf.editProfileTableView.reloadRows(at: [indexPath], with: .none)
                    }
                }
                
            } else {
                let alertType = (errorMessage ?? "" == JFLocalizableConstants.NetworkError) ? AlertType.networkError : AlertType.defaultSystemAlert(message: errorMessage ?? "")
                
                JFAlertViewController.presentAlertController(with: alertType, fromViewController: strongSelf.tabBarController) { success in
                    if success {
                        strongSelf.getProfileData(showHud: showHud)
                    }
                }
            }
        })
    }
}
