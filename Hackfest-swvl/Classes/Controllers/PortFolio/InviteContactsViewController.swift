//
//  InviteContactsViewController.swift
//  Hackfest-swvl
//
//  Created by zaktech on 5/21/18.
//  Copyright © 2018 maskers. All rights reserved.
//

import UIKit

class InviteContactsViewController: JFViewController, KeyboardProtocol {
    
    //MARK:- IBOutlets
    @IBOutlet weak var contactsTableView: UITableView!
    @IBOutlet weak var searchTextField: JFSearchTextField!
    @IBOutlet weak var emptySearchView: UIView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tableViewBottom: NSLayoutConstraint!
    
    
    //MARK:- Public properties
    let searchButton = UIButton(type: .custom)
    var inviteOrInvitedContacts = [JFContactInfo]()
    var searchFilteredData = [JFContactInfo]()
    var isSearchActive = false
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard (_:)))

    //MARK:- UIViewController lifecycle
    deinit {
        print("Deinit called for invite contacts :)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addGestureRecognizer(tapGesture)

        searchViewHeight.constant = 0
        setupNavigation()
        setupKeyboardObservers()
        self.view.backgroundColor = UIColor.appBackGroundColor
        contactsTableView.register(identifiers: [JFUserWithImageCustomCell.self, JFHeaderCustomCell.self])
        
        contactsTableView.estimatedRowHeight = 100
        contactsTableView.rowHeight = UITableViewAutomaticDimension
        contactsTableView.tableFooterView = UIView(frame: .zero)
    }
    
    //MARK:- User actions
    @IBAction func textChanged(_ sender: JFSearchTextField) {
        if  !((sender.text?.isEmpty)!) {
            isSearchActive = true
            filterSearchResult()
        } else {
            isSearchActive = false
            emptySearchView.isHidden = true
            self.contactsTableView.reloadData()
        }
    }
    
    //MARK:- Helper methods
    func filterSearchResult() {
        
        searchFilteredData = inviteOrInvitedContacts.filter() {
            
            let fullName = ($0.fullName).lowercased()
            return fullName.contains(searchTextField.text?.lowercased() ?? "")
        }
        
        searchFilteredData.isEmpty ? (emptySearchView.isHidden = false) : (emptySearchView.isHidden = true)
        
        contactsTableView.reloadData()
    }
    
    func setupKeyboardObservers() {
        addKeyboardShowObserver { [weak self] height in
            self?.tableViewBottom.constant = height - 50
        }
        
        addKeyboardHideObserver { [weak self] in
            self?.tableViewBottom.constant = 0
        }
    }
    
    func setupNavigation() {
        setNavTitle(title: "Contacts")
        searchButton.setImage(#imageLiteral(resourceName: "search_icon_yellow"), for: .selected)
        searchButton.setImage(#imageLiteral(resourceName: "search_icon_grey"), for: .normal)
        
        searchButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        let rightButtomItem = UIBarButtonItem(customView: searchButton)
        customRightButton(button: rightButtomItem)
        
        addBackButton()
    }
    
    @objc func searchButtonTapped() {
        if searchButton.isSelected == false {
            searchButton.isSelected = true
            
            self.searchView.isHidden = false
            
            UIView.animate(withDuration: 1.0) {
                self.searchViewHeight.constant = 60
            }
        } else {
            searchButton.isSelected = false
            
            searchTextField.text = ""
            isSearchActive = false
            emptySearchView.isHidden = true
            self.contactsTableView.reloadData()
            
            self.searchView.isHidden = true
            
            UIView.animate(withDuration: 1.0, animations: {
                self.searchViewHeight.constant = 0
                
            }) { success in
                self.searchTextField.resignFirstResponder()
                self.contactsTableView.reloadData()
            }
        }
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        searchTextField.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchTextField.resignFirstResponder()
    }
}

//MARK:- UITableViewDelegate, UITableViewDataSource
extension InviteContactsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearchActive ? searchFilteredData.count : inviteOrInvitedContacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "JFUserWithImageCustomCell") as! JFUserWithImageCustomCell
        tableView.separatorStyle = .singleLine
        let userData = isSearchActive ? searchFilteredData[indexPath.row] : inviteOrInvitedContacts[indexPath.row]
        cell.configureInviteCellWithDatas(cellData: userData, isButtonTouchEnable: true)
        cell.delegate = self
        cell.inviteButtonCellDelegateIndexPath = indexPath
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchTextField.resignFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JFHeaderCustomCell") as! JFHeaderCustomCell
        
        cell.headerLabel.text = isSearchActive ? "Search Results (\(searchFilteredData.count))" : "\(inviteOrInvitedContacts.count) Contacts"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}

//MARK:- inviteCellDelegate
extension InviteContactsViewController: inviteCellDelegate {
    func buttonTapped(at indexPath: IndexPath) {
        
        JFSendInviteAlertViewController.presentInviteController(with: inviteOrInvitedContacts[indexPath.row], fromViewController: self.tabBarController) { _ in
            print("Successfully invited")
            self.inviteOrInvitedContacts[indexPath.row].status = .invited
            self.contactsTableView.reloadRows(at: [indexPath], with: .none)
        }
    }
}
