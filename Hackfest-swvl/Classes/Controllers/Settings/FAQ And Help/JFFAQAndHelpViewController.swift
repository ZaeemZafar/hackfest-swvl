//
//  JFFAQAndHelpViewController.swift
//  Hackfest-swvl
//
//  Created by zaktech on 9/5/18.
//  Copyright © 2018 Citrusbits. All rights reserved.
//

import UIKit

struct FAQData {
    var opened: Bool
    let showBullets: Bool
    let title: String
    let description: [String]
}

class JFFAQAndHelpViewController: JFViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var faqTableView: UITableView!
    
    
    //MARK:- Public properties
    var faqData = [FAQData]()
    var cellCount = 0
    
    //MARK:- UIViewController lifecycle
    deinit {
        print("Deinit called for FAQ + Help vc :)")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeFAQData()
        setupNavigation()
        
        faqTableView.delegate = self
        faqTableView.dataSource = self
        faqTableView.estimatedRowHeight = 100
        faqTableView.rowHeight = UITableViewAutomaticDimension
    }
    
    
    //MARK:- User actions
    @IBAction func contactUsTapped(_ sender: JFButton) {
        print("Contact Us tapped.")
        openMailComposerWithJFDefaultFormat()
    }
    
    
    //MARK:- Helper methods
    func setupNavigation() {
        title = "FAQ + HELP"
        addBackButton()
    }
    
    func initializeFAQData() {
        
        // Get dictionary object from plist
        
        if let path = Bundle.main.path(forResource: "FAQ_Data", ofType: "plist"),
            let fetchedData = NSArray(contentsOfFile: path) {
            
            for data in fetchedData {
                print(data)
                if let dict : [String: Any] = data as? [String : Any] {
                    faqData.append(FAQData(opened: (dict[FAQDataConstants.fileName.rawValue] ?? false) as! Bool, showBullets: (dict[FAQDataConstants.showBullets.rawValue] ?? false) as! Bool, title: (dict[FAQDataConstants.title.rawValue] ?? "") as! String, description: (dict[FAQDataConstants.description.rawValue] ?? []) as! [String]))
                    
                }
            }
            
        }
        
        //        faqData = [FAQData(opened: false, showBullets: false, title: "Who is Hackfest-swvl?", description: ["A young, ambitious and creative Company founded in 2018 (Justfamous Inc.) who is bringing to the World a disruptive social network"]),
        //                   FAQData(opened: false, showBullets: false, title: "What is the Mission of Hackfest-swvl?", description: ["We want to create Human Brand Equity through Honesty"]),
        //                   FAQData(opened: false, showBullets: false, title: "What is the Vision of Hackfest-swvl?", description: ["We want the World to embrace us as the Universal measure to unlock potential for personal, professional and business growth"]),
        //                   FAQData(opened: false, showBullets: false, title: "How does Hackfest-swvl work?", description: ["You will get and give honest, multi-dimensional feedback by selecting from a menu of 21 words in three categories: Appearance, Intelligence, and Personality. All 21 words have a different value from each other. You can choose up to 3 words every time you want to rate someone. Then the Hackfest-swvl Algorithms will instantly transform your ratings into scores. These scores will continually update as more people rate you, and you can see how your scores in each category as well as your JF Index evolve over time"]),
        //                   FAQData(opened: false, showBullets: false, title: "What is the JF Index all about?", description: ["The JF Index is “your number”. A universal measure that lets you understand and then improve Human Brand Equity for yourself and also for people around you. It is measured and obtained exclusively through the Hackfest-swvl app. The sophisticated algorithms will first take into account your category specific scores and then layer in behavioral data from your in-app activities. You will then witness your personal Human Brand Equity evolve in real time"]),
        //                   FAQData(opened: false, showBullets: true, title: "Who would be thrilled to join Hackfest-swvl?", description: ["You enjoy dishing and receiving honest feedback", "You like to understand how others see and experience them as a person", "You believe in the transformative power of artificial intelligence (AI) to help us understand each other and ourselves better", "You desire better intel on the people in life", "You are convinced that 5-star rating systems are inadequate or inappropriate when it comes to evaluating people", "You want to understand your Human Brand Equity, learn from it, improve it, and use it to seek new opportunities"]),
        //                   FAQData(opened: false, showBullets: true, title: "How is Hackfest-swvl taking social harassment and bullying seriously?", description: ["Hackfest-swvl is age-restricted to users who are at least 18 years old", "Our privacy customization features let you opt out of receiving anonymous feedback", "You can have either a private or public profile", "You can also opt out of being rated entirely, choosing instead to participate only as a truth giver", "Hackfest-swvl prevents users from rating the same person more than once every 60 minutes, encouraging thoughtful ratings", "You are also given the option to block users if needed", "Any suspected harassment or bullying could be immediately reported to Hackfest-swvl: support@justfamous.com"]),
        //                   FAQData(opened: false, showBullets: false, title: "Could I suggest Hackfest-swvl ways to improve the Product?", description: ["Yes, you can share your thoughts with us directly: support@justfamous.com"]),
        //                   FAQData(opened: false, showBullets: false, title: "Are you open for financial Investments?", description: ["Always happy to consider, thanks to contact us directly: support@justfamous.com"])
        //        ]
    }
}

//MARK:- UITableViewDataSource
extension JFFAQAndHelpViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return faqData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return faqData[section].opened ? 2 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let rowData = faqData[indexPath.section]
        if indexPath.row == 0 {
            let titleCell = tableView.dequeueReusableCell(withIdentifier: "JFFAQTitleCustomCell") as! JFFAQTitleCustomCell
            
            titleCell.configureCell(data: rowData)
            
            return titleCell
            
        } else {
            let descriptionCell = tableView.dequeueReusableCell(withIdentifier: "JFFAQDescriptionCustomCell", for: indexPath) as! JFFAQDescriptionCustomCell
            descriptionCell.configureCell(data: rowData) { [weak self] in
                self?.openMailComposerWithJFDefaultFormat()
            }
            
            return descriptionCell
        }
    }
}

//MARK:- UITableViewDelegate
extension JFFAQAndHelpViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if faqData[indexPath.section].opened == true {
            faqData[indexPath.section].opened = false
            
            let section = IndexSet.init(integer: indexPath.section)
            tableView.reloadSections(section, with: .none)
        
        } else {
            faqData[indexPath.section].opened = true
            
            let section = IndexSet.init(integer: indexPath.section)
            tableView.reloadSections(section, with: .none)
        }
    }
    
}
