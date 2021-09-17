//
//  String+JF.swift
//  Hackfest-swvl
//
//  Created by Umair on 02/04/2018.
//  Copyright © 2018 maskers. All rights reserved.
//

import Foundation
import UIKit

extension String {
    var toBool: Bool? {
        
        switch self {
            
        case "True", "true", "yes", "1":
            return true
            
        case "False", "false", "no", "0":
            return false
            
        default:
            return nil
        }
    }
    
    var removeWhitespace: String {
        return self.replace(string: " ", replacement: "")
    }
    
    var normalized: String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let resultPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return resultPredicate.evaluate(with: self)
    }
    
    var isPhoneNumber: Bool {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let matches = detector.matches(in: self, options: [], range: NSMakeRange(0, self.count))
            if let res = matches.first {
                return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == self.count && self.count == JFConstants.minPhoneNumberDigits
            } else {
                return false
            }
        } catch {
            return false
        }
    }
    
    subscript (index: Int) -> String {
        return self[Range(index ..< index + 1)]
    }
    
    subscript (range: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(self.count, range.lowerBound)),
                                            upper: min(self.count, max(0, range.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        let rangeNew = start ..< end
        
        return String(self[rangeNew])
    }
    
    func substring(from: Int) -> String {
        return self[Range(min(from, self.count) ..< self.count)]
    }
    
    func substring(toIndex: Int) -> String {
        return self[Range(0 ..< max(0, toIndex))]
    }
    
    func replace(string: String, replacement: String) -> String {
        return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
    }
    
    func normalizeWebURL() -> URL? {
        
        if self.isEmpty {
            return nil
        }
        
        var urlString = self
        urlString = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let url = URL(string: urlString)
        
        if UIApplication.shared.canOpenURL(url!) {
            return url!
        } else {
            return nil
        }
        
    }
    
    func containsAlphabets() -> Bool {
        return self.unicodeScalars.contains {CharacterSet.letters.contains($0)}
    }
    
    func lastIndexOf(target: String) -> Int? {
        
        if let range = self.range(of: target, options: String.CompareOptions.backwards) {
            return self.distance(from: self.startIndex, to: range.lowerBound)
            
        } else {
            return nil
        }
    }
    
    func stringSize(constrainedToWidth width: Double, font: UIFont) -> CGSize {
        
        return self.boundingRect(with: CGSize(width: width, height: Double.greatestFiniteMagnitude),
                                 options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                 attributes: [NSAttributedStringKey.font: font],
                                 context: nil).size
    }
    
    func extractNumbers() -> String {
        let strComponents = self.components(separatedBy: CharacterSet.decimalDigits.inverted)
        return strComponents.joined(separator: "")
    }
    
    func extractLetters() -> String {
        let strComponents = self.components(separatedBy: CharacterSet.letters.inverted)
        return strComponents.joined(separator: " ")
    }
    func getContents() -> String {
        
        if let path = Bundle.main.path(forResource: self, ofType: "txt") {
            do {
                let text = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
                return text
                
            } catch {
                print("Failed to read text from bundle file \(self)")
            }
        } else {
            print("Failed to load file from bundle \(self)")
        }
        
        return ""
    }
    
    func stringFromHtml() -> NSAttributedString {
        var attrString = NSAttributedString()
        guard let data = self.data(using: .utf8) else { return attrString}
        
        let options = [.documentType: NSAttributedString.DocumentType.html,
                       .characterEncoding: String.Encoding.utf8.rawValue] as [NSAttributedString.DocumentReadingOptionKey : Any]
        
        do {
            attrString = try NSAttributedString(data: data, options: options, documentAttributes: nil)
            
        } catch {
            print(error.localizedDescription)
        }
        
        return attrString
    }
    
    func base64Encoded() -> String? {
        
        if let data = self.data(using: .utf8) {
            return data.base64EncodedString()
        }
        
        return nil
    }
    
    func base64Decoded() -> String? {
        
        if let data = Data(base64Encoded: self) {
            return String(data: data, encoding: .utf8)
        }
        
        return nil
    }
}
