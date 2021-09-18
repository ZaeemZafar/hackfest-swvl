//
//  ProfileInfo.swift
//  Hackfest-swvl
//
//  Created by zaktech on 4/26/18.
//  Copyright © 2018 maskers. All rights reserved.
//

import Foundation
import CoreLocation
import Droar

class ProfileInfo: Codable {

    //MARK:- Private properties
    private var _imageData: Data?
    private var displayFbLink: Bool
    private var jfIndex: JFIndexInfo?
    private var intelligenceIndex: JFIndexInfo?
    private var personalityIndex: JFIndexInfo?
    private var appearanceIndex: JFIndexInfo?
    
    private var locationLatitude: CLLocationDegrees?
    private var locationLongitude: CLLocationDegrees?
    
    //MARK:- Public properties
    var id: String
    var firstName: String
    var lastName: String
    var facebookID: String
    var fbProfileLink: String
    var isFacebookUser: Bool
    var facebookConnected: Bool
    var email: String
    var imagePath: String
    var phone: String
    var traitAppearance: Bool
    var traitPersonality: Bool
    var traitIntelligence: Bool
    var traitNone: Bool
    var notficationEnabled: Bool
    var locationEnabled: Bool
    var scoreScope: String
    var location: String
    var bio: String
    
    
    var given: Int
    var received: Int
    var isCaptainProfile: Bool
    var graphLoaded: Bool
    
    func imageURL(thumbnail: Bool = false) -> URL? {
        let imageBaseURL = thumbnail ? JFConstants.s3ThumbnailImageURL : JFConstants.s3ImageURL
        let urlString =  imageBaseURL + imagePath
        return URL(string: urlString)
    }
    
    //MARK:- Computed properties
    var image: UIImage? {
        get {
            if let data = _imageData {
                return UIImage(data: data)
            }
            return nil
        }
        set {
            if let imageData = newValue {
                _imageData = UIImagePNGRepresentation(imageData)
            }
        }
    }
    
    var graphData: [JFGraph] {
        var graphArray = [JFGraph?]()
        
        graphArray.append(jfIndex?.graphData)
        
        if traitAppearance {
            graphArray.append(appearanceIndex?.graphData)
        }
        
        if traitPersonality {
            graphArray.append(personalityIndex?.graphData)
        }
        
        if traitIntelligence {
            graphArray.append(intelligenceIndex?.graphData)
        }
        
        return graphArray.compactMap({$0})
    }
    
    var displayFBProfileLink:Bool {
        get {
            
            // Developer Note:
            // TODO:
            // For testing purposes only
            if JFConstants.facebookDisabled {
                return false
            
            } else {
                return displayFbLink && (JFSession.shared.myProfile?.facebookConnected ?? false)
            }
            
        }
    }
    
    var locationCoodinate: CLLocationCoordinate2D? {
        get {
            if let lat = locationLatitude, let long = locationLongitude {
                return CLLocationCoordinate2D(latitude: lat, longitude: long)
            }
            return nil
        }
        set {
            locationLatitude = newValue?.latitude
            locationLongitude = newValue?.longitude
        }
    }
    
    //MARK:- Helper methods
    func indexMultiplier(forType type: JFIndexMultiplierType) -> JFIndexInfo? {
        switch type {
        case .appearance:
            return appearanceIndex
            
        case .personality:
            return personalityIndex
            
        case .intelligence:
            return intelligenceIndex
            
        case .jfIndex:
            return jfIndex
        }
    }
    
    //MARK:- Init's
    init() {
        id = "0"
        firstName = ""
        lastName = ""
        facebookID = ""
        isFacebookUser = false
        email = ""
        imagePath = ""
        phone = ""
        traitAppearance = false
        traitPersonality = false
        traitIntelligence = false
        traitNone = false
        notficationEnabled = false
        locationEnabled = false
        isCaptainProfile = false
        scoreScope = ""
        location = ""
        bio = ""
        
        given = 0
        received = 0
        displayFbLink = false
        graphLoaded = false
        facebookConnected = false
        fbProfileLink = ""
    }
    
    init(image: UIImage?, id: String, firstName: String, lastName: String, facebookID: String, isFacebookUser: Bool, email: String, imagePath: String, phone: String, traitAppearance: Bool, traitPersonality: Bool, traitIntelligence: Bool, traitNone: Bool, notficationEnabled: Bool, locationEnabled: Bool, scoreScope: String, location: String, bio: String, given: Int, received: Int, displayFbLink: Bool, jfGraph: Bool, jfIndex: String, jfIndexPercentage: String, appearanceIndex: String, appearanceIndexPercentage: String, personalityIndex: String, personalityIndexPercentage: String, intelligenceIndex: String, intelligenceIndexPercentage: String, profile_public: Bool) {
        
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.facebookID = facebookID
        self.isFacebookUser = isFacebookUser
        self.email = email
        self.imagePath = imagePath
        self.phone = phone
        self.traitAppearance = traitAppearance
        self.traitPersonality = traitPersonality
        self.traitIntelligence = traitIntelligence
        self.traitNone = traitNone
        self.notficationEnabled = notficationEnabled
        self.locationEnabled = locationEnabled
        self.scoreScope = scoreScope
        self.location = location
        self.bio = bio
        
        self.given = given
        self.received = received
        self.displayFbLink = displayFbLink

        self.isCaptainProfile = profile_public
        self.facebookConnected = false
        
        graphLoaded = false
        fbProfileLink = ""
        self.image = image
    }
    
    init(_ info: [String: Any], graphRetrieved: SimpleCompletionBlock?) {
        id = "\(info["id"] as? Int ?? 0)"
        firstName = (info["firstName"] as? String) ?? ""
        lastName = (info["lastName"] as? String) ?? ""
        facebookID = (info["facebookId"] as? String) ?? ""
        isFacebookUser = (info["isFacebookUser"] as? Bool) ?? false
        fbProfileLink = (info["fbProfileLink"] as? String) ?? ""
        
        email = (info["email"] as? String) ?? ""
        imagePath = (info["image"] as? String) ?? ""
        phone = (info["phoneNumber"] as? String) ?? ""
        location = (info["location"] as? String) ?? ""
        bio = (info["biography"] as? String) ?? ""
        locationLatitude = info["latitude"] as? CLLocationDegrees
        locationLongitude = info["longitude"] as? CLLocationDegrees
        
        let settingsInfo = (info["settings"] as? [String: Any]) ?? [String: Any]()
        let multiplierInfo = (info["multiplierInfo"] as? [String: Any]) ?? [String: Any]()
        
        traitAppearance = (settingsInfo["traitAppearance"] as? Bool) ?? false
        traitPersonality = (settingsInfo["traitPersonality"] as? Bool) ?? false
        traitIntelligence = (settingsInfo["traitIntelligence"] as? Bool) ?? false
        traitNone = (settingsInfo["traitNone"] as? Bool) ?? false
        notficationEnabled = (settingsInfo["notificationsEnabled"] as? Bool) ?? false
        locationEnabled = (settingsInfo["locationEnabled"] as? Bool) ?? false
        isCaptainProfile = (settingsInfo["isCaptainProfile"] as? Bool) ?? false
        scoreScope = (settingsInfo["scoreScope"] as? String) ?? ""
        displayFbLink = (settingsInfo["displayFacebookProfile"] as? Bool) ?? false
        
        given = multiplierInfo["ratingsGiven"] as? Int ?? 0
        received = multiplierInfo["ratingsReceived"] as? Int ?? 0
        facebookConnected = (settingsInfo["facebookConnected"] as? Bool) ?? false
        graphLoaded = false
        image = UIImage(named: "profile_icon_placeholder")
        
        // Initialize graph data from cache
        self.jfIndex = JFSession.shared.myProfile?.jfIndex
        self.intelligenceIndex = JFSession.shared.myProfile?.intelligenceIndex
        self.personalityIndex = JFSession.shared.myProfile?.personalityIndex
        self.appearanceIndex = JFSession.shared.myProfile?.appearanceIndex
        
        let placeHolderImageView = UIImageView()
        
        placeHolderImageView.jf_setImage(withURL: imageURL(), placeholderImage: UIImage(named: "profile_icon_placeholder"), showIndicator: false) { [weak self] in
            self?.image = placeHolderImageView.image
        }
        
        updateGraphData(onCompletion: graphRetrieved)
    }
    
    func updateGraphData(onCompletion: SimpleCompletionBlock?) {
        let graphEndPoint = JFUserEndpoint.graphUser(userId: self.id)
        JFWSAPIManager.shared.sendJFAPIRequest(apiConfig: graphEndPoint) { [weak self] (response: JFWepAPIResponse<GraphUserAPIBase>) in

            if response.success { // successfully invited
                guard let userIndexData = response.data?.graphUserData else {return}
                
                self?.jfIndex = JFIndexInfo(withJFIndex: userIndexData.jfIndex, jfMultiplier: userIndexData.jfMultiplier, jfRateOfChange: userIndexData.rateOfChange)
                self?.intelligenceIndex = JFIndexInfo(withJFIndex: userIndexData.intelligenceAverage, jfMultiplier: nil, jfRateOfChange: userIndexData.intelligenceRateOfChange)
                self?.personalityIndex = JFIndexInfo(withJFIndex: userIndexData.personalityAverage, jfMultiplier: nil, jfRateOfChange: userIndexData.personalityRateOfChange)
                self?.appearanceIndex = JFIndexInfo(withJFIndex: userIndexData.appearanceAverage, jfMultiplier: nil, jfRateOfChange: userIndexData.appearanceRateOfChange)
                
               
                // Graphdata manipulation
                guard let userGraphData = response.data?.graphUserData?.graphData else {return}
                let processingTimeString = userGraphData.last?.processingTime ?? ""
                let processingDate = Date(fromString: processingTimeString, format: DateFormatType.isoDateTimeMilliSec) ?? Date()
                
                let originprocessingTimeString = response.data?.graphUserData?.createdAt ?? ""
                let originProcessingDate = Date(fromString: originprocessingTimeString, format: DateFormatType.isoDateTimeMilliSec) ?? Date()
                
                let jfGraphDataPoint = userGraphData.compactMap({$0.jfim})
                let jfIntelDataPoint = userGraphData.compactMap({$0.intelligenceAverage})
                let jfAppearDataPoint = userGraphData.compactMap({$0.appearanceAverage})
                let jfPersonDataPoint = userGraphData.compactMap({$0.personalityAverage})
                
                self?.jfIndex?.graphData = JFGraph(with: .jfIndex, data_points: jfGraphDataPoint, recent_processing_date: processingDate, origin_processing_date: originProcessingDate)
                self?.intelligenceIndex?.graphData = JFGraph(with: .intelligence, data_points: jfIntelDataPoint, recent_processing_date: processingDate, origin_processing_date: originProcessingDate)
                self?.personalityIndex?.graphData = JFGraph(with: .personality, data_points: jfPersonDataPoint, recent_processing_date: processingDate, origin_processing_date: originProcessingDate)
                self?.appearanceIndex?.graphData = JFGraph(with: .appearance, data_points: jfAppearDataPoint, recent_processing_date: processingDate, origin_processing_date: originProcessingDate)
                
                self?.graphLoaded = true
            }
            
            onCompletion?()
        }
    }
}
