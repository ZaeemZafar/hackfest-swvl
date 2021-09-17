//
//  JFLandingViewController.swift
//  Hackfest-swvl
//
//  Created by zaktech on 4/3/18.
//  Copyright © 2018 Citrusbits. All rights reserved.
//

import UIKit

class JFLandingViewController: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    
    //MARK:- Public properties
    var pageController: UIPageViewController!
    var currentIndex: Int = 0
    var pendingIndex: Int?
    
    //MARK:- UIViewController lifecycle
    deinit {
        print("Deinit called for landing vc :)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageControllerSet()
    }
    
    override func viewWillLayoutSubviews() {
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // increase page control's size
        pageControl.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
    }
    
    //MARK:- User actions
    @IBAction func signUpTapped(_ sender: JFButton) {
        //Crashlytics.sharedInstance().crash()
        print("Signup tapped")
    }
    
    @IBAction func logInTapped(_ sender: JFButton) {
        print("Login tapped")
    }
    
    //MARK:- Helper methods
    func setupUI() {
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        pageController.view.frame = CGRect(x: contentView.frame.origin.x + 1, y: contentView.frame.origin.y + 1, width: contentView.frame.size.width - 2, height: contentView.frame.size.height - 2)
        //pageController.view.frame = contentView.frame
        
        //pageController.view.frame.size.height = contentView.frame.size.height + 25
        
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.black.cgColor
    }
    
    func pageControllerSet() {
        pageController = UIPageViewController(transitionStyle: UIPageViewControllerTransitionStyle.scroll, navigationOrientation: UIPageViewControllerNavigationOrientation.horizontal, options: nil)
        
        pageController.dataSource = self
        pageController.delegate = self
        let initialViewController: JFTutorialViewController = viewControllerAtIndex(index: currentIndex)
        let viewControllers: NSArray = NSArray(object: initialViewController)
        
        pageController.setViewControllers((viewControllers as? [UIViewController]), direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
        
        addChildViewController(pageController)
        view.addSubview(pageController.view)
        pageController.didMove(toParentViewController: self)
    }
    
    func viewControllerAtIndex(index: NSInteger) -> JFTutorialViewController {
        let childVC = getTutorialVC()
        childVC.index = index
        return childVC
    }
}

//MARK:- UIPageViewControllerDataSource, UIPageViewControllerDelegate
extension JFLandingViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as? JFTutorialViewController)?.index
        
        if index == 0 {
            return nil
        }
        // Decrease the index by 1 to return
        index = index! - 1
        return viewControllerAtIndex(index: index!)
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as? JFTutorialViewController)?.index
        currentIndex = index!
        
        index = index! + 1
        if index == 3 {
            return nil
        }
        
        return self.viewControllerAtIndex(index: index!)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        
        pendingIndex = (pendingViewControllers.first as? JFTutorialViewController)?.index
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            if let index = pendingIndex {
            pageControl.currentPage = index
            }
        }
    }
}
