//
//  MBProgressHUD+JF.swift
//  Hackfest-swvl
//
//  Created by Umair on 16/04/2018.
//  Copyright © 2018 maskers. All rights reserved.
//

import Foundation
import UIKit

extension MBProgressHUD {

    @discardableResult
    class func showCustomHUDAddedTo(view: UIView, animated: Bool) -> MBProgressHUD? {
        return MBProgressHUD.showCustomHUDAddedTo(view: view, title: nil, animated: animated)
    }
    
    @discardableResult
    class func showCustomHUDAddedTo(view: UIView?, title: String?, animated: Bool) -> MBProgressHUD? {
        
        guard let viewToAdd = view else {return nil}
        
        let containerView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 120.0, height: 80.0))
        containerView.backgroundColor = UIColor.clear
        
        let activityView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityView.color = UIColor.jfDarkBrown
        
        activityView.startAnimating()
        
        containerView.addSubview(activityView)
        
        activityView.center = containerView.center
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        let cvWidthConstraint = NSLayoutConstraint(item: containerView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: 120.0)
        let cvHeightConstraint = NSLayoutConstraint(item: containerView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 80.0)
        
        containerView.addConstraints([cvWidthConstraint, cvHeightConstraint])
        
        let progressHUD = MBProgressHUD(view: viewToAdd)
        
        progressHUD.backgroundView.color = UIColor(white: 0.0, alpha: 0.6)
        progressHUD.backgroundView.style = MBProgressHUDBackgroundStyle.solidColor
        
        progressHUD.bezelView.color = UIColor.white
        progressHUD.bezelView.style = MBProgressHUDBackgroundStyle.blur
        
        viewToAdd.addSubview(progressHUD)
        
        progressHUD.mode = MBProgressHUDMode.customView
        progressHUD.customView = containerView
        progressHUD.label.text = title
        
        progressHUD.label.font = UIFont.normal(fontSize: 14)
        progressHUD.label.textColor = UIColor.jfDarkBrown
        
        progressHUD.detailsLabel.font = UIFont.normal(fontSize: 12.0)
        progressHUD.detailsLabel.textColor = UIColor.jfDarkBrown

        
        progressHUD.show(animated: true)
        
        return progressHUD
    }
    
    @discardableResult
    class func showConfirmationCustomHUDAddedTo(view: UIView?, title: String?, image: UIImage, animated: Bool) -> MBProgressHUD? {
        guard let viewToAdd = view else {return nil}
        
        let containerView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 50.0, height: 25.0))
        containerView.layer.cornerRadius = 4.0
        containerView.backgroundColor = UIColor.clear
        
        let imageView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: 22.6, height: 16.0))
        imageView.image = image
        containerView.addSubview(imageView)
        imageView.center = containerView.center
        //imageView.frame.origin.y = -10.0
        
        containerView.translatesAutoresizingMaskIntoConstraints = true
        
        let cvWidthConstraint = NSLayoutConstraint(item: containerView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: 50.0)
        let cvHeightConstraint = NSLayoutConstraint(item: containerView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 25.0)
        
        containerView.addConstraints([cvWidthConstraint, cvHeightConstraint])
        
        let progressHUD = MBProgressHUD(view: viewToAdd)
        
        progressHUD.backgroundView.color = UIColor(white: 0.0, alpha: 0.6)
        progressHUD.backgroundView.style = MBProgressHUDBackgroundStyle.solidColor
        
        progressHUD.bezelView.color = UIColor.white
        progressHUD.bezelView.style = MBProgressHUDBackgroundStyle.blur
        
        viewToAdd.addSubview(progressHUD)
        
        progressHUD.mode = MBProgressHUDMode.customView
        progressHUD.customView = containerView
        //progressHUD.customView = UIImageView(image: image)
        progressHUD.label.text = title
        
        progressHUD.label.font = UIFont.normal(fontSize: 14.0)
        progressHUD.label.textColor = UIColor.jfDarkGray
        
        progressHUD.detailsLabel.font = UIFont.normal(fontSize: 12.0)
        progressHUD.detailsLabel.textColor = UIColor.jfDarkBrown
        
        progressHUD.show(animated: true)

        return progressHUD
    }
    
    @discardableResult
    class func hides(for view: UIView?, animated: Bool) -> Bool {
        guard let viewToHide = view else {return false}
        
        return MBProgressHUD.hide(for: viewToHide, animated: animated)
    }
}
