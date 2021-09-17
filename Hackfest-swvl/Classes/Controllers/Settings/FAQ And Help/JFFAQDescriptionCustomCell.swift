//
//  JFFAQDescriptionCustomCell.swift
//  Hackfest-swvl
//
//  Created by zaktech on 9/5/18.
//  Copyright © 2018 maskers. All rights reserved.
//

import UIKit

class JFFAQDescriptionCustomCell: UITableViewCell {

    @IBOutlet weak var simpleTextView: UITextView!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var tappedLinkCompletion: SimpleCompletionBlock?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        descriptionTextView.delegate = self
        simpleTextView.delegate = self
    }
    
    override func prepareForReuse() -> Void {
        descriptionTextView.text = nil
        descriptionTextView.attributedText = nil
        tappedLinkCompletion = nil
    }
    
    func configureCell(data: FAQData, linkDetection: SimpleCompletionBlock?) {
        descriptionTextView.textColor = UIColor.jfMediumGray
        descriptionTextView.alpha = 0
        simpleTextView.alpha = 0
        
        if data.showBullets {
            descriptionTextView.attributedText = createBulletedList(fromStringArray: data.description, font: descriptionTextView.font)

            descriptionTextView.alpha = 1
            simpleTextView.alpha = 0
            
        } else {
            descriptionTextView.alpha = 0
            simpleTextView.alpha = 1
            simpleTextView.text = data.description[0]
        }
        
        tappedLinkCompletion = linkDetection
    }
    
    private func createBulletedList(fromStringArray strings: [String], font: UIFont? = nil) -> NSAttributedString {
        
        let fullAttributedString = NSMutableAttributedString()
        let attributesDictionary: [NSAttributedStringKey: Any]
        
        if font != nil {
            attributesDictionary = [NSAttributedStringKey.font: font!, NSAttributedStringKey.foregroundColor: UIColor.jfMediumGray]
        } else {
            attributesDictionary = [NSAttributedStringKey: Any]()
        }
        
        for index in 0..<strings.count {
            let bulletPoint: String = "\u{2022}"
            var formattedString: String = "\(bulletPoint) \(strings[index])"
            
            if index < strings.count - 1 {
                formattedString = "\(formattedString)\n"
            }
            
            let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: formattedString, attributes: attributesDictionary)
            let paragraphStyle = createParagraphAttribute()
            attributedString.addAttributes([NSAttributedStringKey.paragraphStyle: paragraphStyle], range: NSMakeRange(0, attributedString.length))
            fullAttributedString.append(attributedString)
        }
        
        return fullAttributedString
    }
    
    private func createParagraphAttribute() ->NSParagraphStyle {
        let paragraphStyle: NSMutableParagraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.tabStops = [NSTextTab(textAlignment: .left, location: 15, options: NSDictionary() as! [NSTextTab.OptionKey : Any])]
        
        paragraphStyle.defaultTabInterval = 10
        paragraphStyle.firstLineHeadIndent = 0
        paragraphStyle.headIndent = 9
        
        return paragraphStyle
    }
}

extension JFFAQDescriptionCustomCell: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        
        tappedLinkCompletion?()
        
        return true
    }
}
