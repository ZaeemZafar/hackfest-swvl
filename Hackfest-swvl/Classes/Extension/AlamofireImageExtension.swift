//
//  AlamofireImageExtension.swift
//  Hackfest-swvl
//
//  Created by ZaeemZafar on 10/07/2018.
//  Copyright © 2018 Citrusbits. All rights reserved.
//

import Foundation


extension UIImageView {
    func jf_setImage(withURL: URL?, placeholderImage: UIImage?, showIndicator: Bool = true, completion: SimpleCompletionBlock? = nil) {
        if let imageURL = withURL {
            // Create an activity indicator from UIImageView frame - padding
            // Add as subview
            // Remove on completion
            
            let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            activityIndicator.frame = bounds
            activityIndicator.tintColor = .red
            activityIndicator.hidesWhenStopped = true
            addSubview(activityIndicator)
            activityIndicator.startAnimating()
            
            af_setImage(withURL: imageURL, placeholderImage: placeholderImage) { (response) in
                activityIndicator.stopAnimating()
                completion?()
            }
            
        } else {
            self.image = placeholderImage
        }
    }
}
