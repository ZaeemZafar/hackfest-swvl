//
//  JFValidator.swift
//  Hackfest-swvl
//
//  Created by zaktech on 4/3/18.
//  Copyright © 2018 maskers. All rights reserved.
//

import Foundation

class JFValidator {
    
    class var shared: JFValidator {
        let shared = JFValidator()
        return shared
    }
    
    func isValidName(text: String) -> Bool {
        let nameRegEx = "^[^ ][a-zA-Z ’'.-]{1,20}"
        
        let namePredicate = NSPredicate(format:"SELF MATCHES %@", nameRegEx)
        return namePredicate.evaluate(with: text)
    }
    
    func isValidEmail(text: String) -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPredicate.evaluate(with: text)
    }
    
    func isValidPassword(text: String) -> Bool {
        //Minimum 8 characters at least 1 Alphabet and 1 Number
        let passwordRegEx = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[$@$!%*#?&])[A-Za-z\\d$@$!%*#?&]{8,}$"
        
        let passwordPredicate = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        return passwordPredicate.evaluate(with: text)
    }
        
}

