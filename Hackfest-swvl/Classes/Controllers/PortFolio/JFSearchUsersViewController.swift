//
//  SearchUsersViewController.swift
//  Hackfest-swvl
//
//  Created by zaktech on 5/9/18.
//  Copyright © 2018 maskers. All rights reserved.
//

import UIKit

class JFSearchUsersViewController: JFViewController, KeyboardProtocol {
    
    //MARK:- IBOutlets
    @IBOutlet weak var topUsersTableView: UITableView!
    @IBOutlet weak var cancelButtonWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchTextField: JFSearchTextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var clearTextButton: UIButton!
    @IBOutlet weak var emptySearchView: UIView!
    
    //MARK:- Public properties
    var metadata: APIMetadata?
    lazy var usersList = [JFProfile]()
    var headerText = ""
    var filter = UserFilter()
    var searchFilteredData = [JFProfile]()
    var btnRight = UIButton(type: .custom)
    var searchDataLoaded = false
    var applyingFilter = false
    var followingCellTypes: [Int] = [CellType.negativeIndex.rawValue,CellType.postiveIndex.rawValue,CellType.notAcceptingRating.rawValue,CellType.postiveIndex.rawValue,CellType.negativeIndex.rawValue,CellType.postiveIndex.rawValue,CellType.negativeIndex.rawValue, CellType.postiveIndex.rawValue,CellType.negativeIndex.rawValue]
    
    var userUpdated: ((JFProfile) -> ())?
    lazy private var searchTimer: Timer = Timer()
    
    var isSearchActive = false {
        didSet {
            metadata?.resetMetadata()
            topUsersTableView.cr.resetNoMore()
            usersList.removeAll()
            searchFilteredData.removeAll()
            
            clearTextButton.isHidden = !isSearchActive
            
            if isSearchActive == false {
                searchTextField.text = ""
            }
        }
    }
    
    //MARK:- UIViewController lifecycle
    deinit {
        print("Deinit called for search user vc :)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableViewForPagination()
        setupKeyboardObservers()
        
        setupNavigation()
        
        topUsersTableView.register(identifiers: [JFUserWithImageCustomCell.self, JFHeaderCustomCell.self])
        
        topUsersTableView.estimatedRowHeight = 100
        topUsersTableView.rowHeight = UITableViewAutomaticDimension
        topUsersTableView.sectionHeaderHeight = UITableViewAutomaticDimension
        topUsersTableView.estimatedSectionHeaderHeight = 100
        topUsersTableView.tableFooterView = UIView(frame: .zero)
        
        applyFilters()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.topUsersTableView.reloadData()
    }
    
    //MARK:- User actions
    @IBAction func cancelTapped() {
        view.endEditing(true)
        
        isSearchActive = false
        topUsersTableView.reloadData()
        getJVFUsers()
    }
    
    @IBAction func textChanged(_ sender: JFSearchTextField) {
        searchFilteredData.removeAll()
        
        isSearchActive = (sender.text?.count ?? 0) > 0
        
        self.searchTimer.invalidate()
        self.searchTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(performSearch), userInfo: nil, repeats: false)
    }
    
    @IBAction func clearText() {
        isSearchActive = false
        getJVFUsers()
    }
    
    //MARK:- Helper methods
    func setupKeyboardObservers() {
        
        addKeyboardShowObserver { [weak self] height in
            self?.tableViewBottomConstraint.constant = height - 50
        }
        
        addKeyboardHideObserver { [weak self] in
            self?.tableViewBottomConstraint.constant = 0
        }
    }
    
    @objc func performSearch() {
        usersList.removeAll()
        searchFilteredData.removeAll()
        metadata?.resetMetadata()
        topUsersTableView.cr.resetNoMore()
        
        getJVFUsers()
    }
    
    func applyFilters() {
        
        if applyingFilter {
            return
        }
        
        applyingFilter = true
        setupNavigation(isFilterActive: filter.filterActive)
        
        if filter.filterActive {
            headerText = filter.getHeaderText()
        }
        
        metadata?.resetMetadata()
        usersList.removeAll()
        searchFilteredData.removeAll()
        
        getJVFUsers { [weak self] success in
            self?.applyingFilter = false
        }
        
    }

    func setupNavigation(isFilterActive: Bool = false) {
        
        self.navigationItem.title = "SEARCH"
        addBackButton()
    }
    
    @objc func showRefineResaultScreen() {
        let refineResultsVC = getRefineResultsVC()
        filter.sort = filter.filterActive ? filter.sort : .none
        if !filter.filterActive {
            filter.reset()
        }
        refineResultsVC.filter = filter.getCopy()
        refineResultsVC.onFilterChange = { [weak self] newFilter in
            self?.filter = newFilter
            
            self?.topUsersTableView.setContentOffset(.zero, animated: false)
            self?.applyFilters()
        }
        
        let navigationController = UINavigationController(rootViewController: refineResultsVC)
        self.present(navigationController, animated: true, completion: nil)
    }

    func filterSearchResult() {
        
        searchFilteredData = usersList.filter {
            let fullName = ($0.firstName + " " + $0.lastName).lowercased()
            return fullName.contains(searchTextField.text?.lowercased() ?? "")
        }
        
        searchFilteredData.isEmpty ? (emptySearchView.isHidden = false) : (emptySearchView.isHidden = true)
        
        self.topUsersTableView.reloadData()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       searchTextField.resignFirstResponder()
    }
}

//MARK:- UITextFieldDelegate
extension JFSearchUsersViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.cancelButtonWidthConstraint.constant = 80
        self.cancelButton.isHidden = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.cancelButtonWidthConstraint.constant = 0
        self.cancelButton.isHidden = true
    }
}

//MARK:- UITableViewDelegate, UITableViewDataSource
extension JFSearchUsersViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearchActive ? searchFilteredData.count : usersList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JFUserWithImageCustomCell") as! JFUserWithImageCustomCell
        tableView.separatorStyle = .singleLine
        guard let userData = isSearchActive ? searchFilteredData[safe: indexPath.row] : usersList[safe: indexPath.row]
            else {
                cell.resetState()
                return cell
        }
        
        
        if filter.filterActive {
            cell.configureCellWithData(cellData: userData, isFilterOn: filter.filterActive, filter: filter)
            
        } else {
            cell.configureCellWithData(cellData: userData, isFilterOn: filter.filterActive)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let profileVC = getUserProfileVC()
        
        let dataArray = isSearchActive ? searchFilteredData : usersList
        profileVC.userData = dataArray[indexPath.row]
        profileVC.userUpdated = { [weak self] userProfile in
            self?.searchFilteredData.updateJFProfile(userProfile: userProfile)
            self?.usersList.updateJFProfile(userProfile: userProfile)
            self?.userUpdated?(userProfile)
        }
        
        self.navigationController?.pushViewController(profileVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JFHeaderCustomCell") as! JFHeaderCustomCell
        
        cell.headerLabel.text = filter.filterActive ? headerText : isSearchActive ? "Search Results (\(metadata?.totalCount ?? 0))" : "Top Users"
        
        return cell
    }
    
}

//MARK:- Network calls
extension JFSearchUsersViewController {
    func getJVFUsers(showHUD: Bool = true, completion: CompletionBlockWithBool? = nil) {
        filter.page = metadata?.page ?? 1
        filter.limit = JFConstants.paginationPageLimit
        filter.search = searchTextField.text ?? ""
        filter.sort = filter.filterActive == false ? .highestToLowest : filter.sort
        
        let endPoint = JFUserEndpoint.discover(filter: filter)
        
        let userData = isSearchActive ? searchFilteredData : usersList
        
        if userData.count < 1 && showHUD {
            let titleText = isSearchActive ? JFLoadingTitles.searchingUsers : JFLoadingTitles.loadingUsers
            MBProgressHUD.showCustomHUDAddedTo(view: self.tabBarController?.view, title: titleText, animated: true)
        }
        
        JFWSAPIManager.shared.sendJFAPIRequest(apiConfig: endPoint) { [weak self] (response: JFWepAPIResponse<UsersNetworkAPIBase>) in
            
            guard let strongSelf = self else { return }
            
            MBProgressHUD.hides(for: strongSelf.tabBarController?.view, animated: true)
            
            if response.success {
                
                guard let apiNetworkData = response.data?.networkData else {return}
                guard let apiMetaData = response.data?.metadata else {return}
                
                strongSelf.metadata = apiMetaData
                
                if strongSelf.isSearchActive {
                    strongSelf.searchFilteredData.append(contentsOf: apiNetworkData.map({JFProfile(profileData: $0)}))
                    strongSelf.searchFilteredData.removeDuplicates()
                    strongSelf.emptySearchView.isHidden = strongSelf.searchFilteredData.isEmpty == false

                } else {
                    strongSelf.usersList.append(contentsOf: apiNetworkData.map({JFProfile(profileData: $0)}))
                    strongSelf.usersList.removeDuplicates()
                    strongSelf.emptySearchView.isHidden = strongSelf.usersList.isEmpty == false
                }
                                
                self?.topUsersTableView.reloadData()
                
            } else {
                let alertType = (response.message == JFLocalizableConstants.NetworkError) ? AlertType.networkError : AlertType.defaultSystemAlert(message: response.message )
                
                JFAlertViewController.presentAlertController(with: alertType, fromViewController: strongSelf.tabBarController) { success in
                    if success {
                        strongSelf.getJVFUsers()
                    }
                }
            }
            
            completion?(response.success)
        }
    }
}

//MARK:- Table Pagination
extension JFSearchUsersViewController {
    
    func configureTableViewForPagination() {
        self.topUsersTableView.cr.addHeadRefresh(animator: NormalHeaderAnimator()) { [weak self] in
            guard let strongSelf = self else {return}
            strongSelf.metadata?.resetMetadata()
            strongSelf.topUsersTableView.cr.resetNoMore()
            strongSelf.usersList.removeAll()
            strongSelf.searchFilteredData.removeAll()
            
            strongSelf.getJVFUsers(showHUD: false) { _ in
                self?.topUsersTableView.cr.endHeaderRefresh()
            }
        }
        
        self.topUsersTableView.cr.addFootRefresh(animator: NormalFooterAnimator()) { [weak self] in
            guard let strongSelf = self else {return}
            guard let currentPage = strongSelf.metadata?.page else {return}
            guard let totalPages = strongSelf.metadata?.totalPages else {return}
            
            if currentPage < totalPages {
                strongSelf.metadata!.page = strongSelf.metadata!.page! + 1
                
                strongSelf.getJVFUsers() { success in
                    strongSelf.topUsersTableView.cr.endLoadingMore()
                    
                    if success && strongSelf.metadata?.page == strongSelf.metadata?.totalPages {
                        strongSelf.topUsersTableView.cr.noticeNoMoreData()
                    }
                }
            } else {
                /// Reset no more data
                strongSelf.topUsersTableView.cr.noticeNoMoreData()
            }
        }
    }
}
