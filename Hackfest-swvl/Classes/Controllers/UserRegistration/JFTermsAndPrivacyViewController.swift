//
//  JFTermsAndPrivacyViewController.swift
//  Hackfest-swvl
//
//  Created by zaktech on 4/18/18.
//  Copyright © 2018 maskers. All rights reserved.
//

import UIKit
import WebKit

enum TermsAndPrivacyWebRequest {
    case termsAndConditions, privacyPolicy, about
}

class JFTermsAndPrivacyViewController: JFViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK:- Public properties
    var currentWebRequest: TermsAndPrivacyWebRequest!
    
    //MARK:- UIViewController lifecycle
    deinit {
        print("Deinit called for terms and privacy vc :)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    //MARK:- User actions
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK:- Helper methods
    func setup() {

        var urlString = ""
        
        switch currentWebRequest {
            
        case .termsAndConditions:
            urlString = JFConstants.termAndConditionsLink
            titleLabel.text = "Terms and Conditions"
        case .privacyPolicy:
            urlString = JFConstants.privacyPolicyLink
            titleLabel.text = "Privacy Policy"
        case .about:
            urlString = JFConstants.aboutHackfestswvlLink
            titleLabel.text = "About Hackfest-swvl"
        default:
            break
        }
        
        let url = URL(string: urlString)

        let request: URLRequest!
        request = URLRequest(url: url!)

        webView.load(request)
    }
    
    func startActivityIndicatior() {
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = .gray
        
        activityIndicator.startAnimating()
    }
    
    func stopActivityIndicatior() {
        activityIndicator.stopAnimating()
    }
}

//MARK:- UIWebViewDelegate
extension JFTermsAndPrivacyViewController:  UIWebViewDelegate {
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        let urlScheme = request.url?.scheme ?? ""

        if navigationType == .linkClicked {
            
            if urlScheme.contains("mailto") {
                let email = request.url?.absoluteString.replace(string: "mailto:", replacement: "") ?? ""
                
                self.openMailComposerWithJFDefaultFormat(toEmail: email)
            
            } else {
                if let url = request.url {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
            
            return false
        }
        
        
        return true
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        startActivityIndicatior()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        stopActivityIndicatior()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        stopActivityIndicatior()
    }
}
