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
    
    private var friendlyIndex: JFIndexInfo?
    private var dressingIndex: JFIndexInfo?
    private var iqLevelIndex: JFIndexInfo?
    private var communicationIndex: JFIndexInfo?
    private var personalityIndex: JFIndexInfo?
    private var behaviorIndex: JFIndexInfo?
    private var cleanlinessIndex: JFIndexInfo?
    private var punctualityIndex: JFIndexInfo?
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
    var trait1: Bool
    var trait2: Bool
    var trait3: Bool
    var trait4: Bool
    var trait5: Bool
    var trait6: Bool
    var trait7: Bool
    var trait8: Bool
    var trait9: Bool
    
    var notficationEnabled: Bool
    var locationEnabled: Bool
    var scoreScope: String
    var location: String
    var bio: String
    
    
    var given: Int
    var received: Int
    var isPublicProfile: Bool
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
        
        if trait1 {
            graphArray.append(friendlyIndex?.graphData)
        }
        if trait2 {
            graphArray.append(dressingIndex?.graphData)
        }
        if trait3 {
            graphArray.append(iqLevelIndex?.graphData)
        }
        if trait4 {
            graphArray.append(communicationIndex?.graphData)
        }
        if trait5 {
            graphArray.append(personalityIndex?.graphData)
        }
        if trait6 {
            graphArray.append(behaviorIndex?.graphData)
        }
        if trait7 {
            graphArray.append(cleanlinessIndex?.graphData)
        }
        if trait8 {
            graphArray.append(punctualityIndex?.graphData)
        }
        if trait9 {
            graphArray.append(appearanceIndex?.graphData)
        }
        
        return graphArray.compactMap({$0})
    }
    
    var displayFBProfileLink: Bool {
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
        case .friendly: return friendlyIndex
        case .dressing: return dressingIndex
        case .iqLevel: return iqLevelIndex
        case .communication: return communicationIndex
        case .personality: return personalityIndex
        case .behavior: return behaviorIndex
        case .cleanliness: return cleanlinessIndex
        case .punctuality: return punctualityIndex
        case .appearance: return appearanceIndex
            
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
        trait1 = false
        trait2 = false
        trait3 = false
        trait4 = false
        trait5 = false
        trait6 = false
        trait7 = false
        trait8 = false
        trait9 = false
        notficationEnabled = false
        locationEnabled = false
        isPublicProfile = false
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
    
    init(image: UIImage?, id: String, firstName: String, lastName: String, facebookID: String, isFacebookUser: Bool, email: String, imagePath: String, phone: String, trait1: Bool, trait2: Bool,  trait3: Bool,  trait4: Bool,  trait5: Bool,  trait6: Bool,  trait7: Bool,  trait8: Bool,  trait9: Bool, notficationEnabled: Bool, locationEnabled: Bool, scoreScope: String, location: String, bio: String, given: Int, received: Int, displayFbLink: Bool, jfGraph: Bool, jfIndex: String, jfIndexPercentage: String, appearanceIndex: String, appearanceIndexPercentage: String, personalityIndex: String, personalityIndexPercentage: String, intelligenceIndex: String, intelligenceIndexPercentage: String, profile_public: Bool) {
        
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.facebookID = facebookID
        self.isFacebookUser = isFacebookUser
        self.email = email
        self.imagePath = imagePath
        self.phone = phone
        
        self.trait1 = trait1
        self.trait2 = trait2
        self.trait3 = trait3
        self.trait4 = trait4
        self.trait5 = trait5
        self.trait6 = trait6
        self.trait7 = trait7
        self.trait8 = trait8
        self.trait9 = trait9
        
        
        self.notficationEnabled = notficationEnabled
        self.locationEnabled = locationEnabled
        self.scoreScope = scoreScope
        self.location = location
        self.bio = bio
        
        self.given = given
        self.received = received
        self.displayFbLink = displayFbLink

        self.isPublicProfile = profile_public
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
        
        trait1 = (settingsInfo["trait1"] as? Bool) ?? false
        trait2 = (settingsInfo["trait2"] as? Bool) ?? false
        trait3 = (settingsInfo["trait3"] as? Bool) ?? false
        trait4 = (settingsInfo["trait4"] as? Bool) ?? false
        trait5 = (settingsInfo["trait5"] as? Bool) ?? false
        trait6 = (settingsInfo["trait6"] as? Bool) ?? false
        trait7 = (settingsInfo["trait7"] as? Bool) ?? false
        trait8 = (settingsInfo["trait8"] as? Bool) ?? false
        trait9 = (settingsInfo["trait9"] as? Bool) ?? false
        
        
        notficationEnabled = (settingsInfo["notificationsEnabled"] as? Bool) ?? false
        locationEnabled = (settingsInfo["locationEnabled"] as? Bool) ?? false
        isPublicProfile = (settingsInfo["isPublicProfile"] as? Bool) ?? false
        scoreScope = (settingsInfo["scoreScope"] as? String) ?? ""
        displayFbLink = (settingsInfo["displayFacebookProfile"] as? Bool) ?? false
        
        given = multiplierInfo["ratingsGiven"] as? Int ?? 0
        received = multiplierInfo["ratingsReceived"] as? Int ?? 0
        facebookConnected = (settingsInfo["facebookConnected"] as? Bool) ?? false
        graphLoaded = false
        image = UIImage(named: "profile_icon_placeholder")
        
        // Initialize graph data from cache
        self.jfIndex = JFSession.shared.myProfile?.jfIndex
        
        
        friendlyIndex = JFSession.shared.myProfile?.friendlyIndex
        dressingIndex = JFSession.shared.myProfile?.dressingIndex
        iqLevelIndex = JFSession.shared.myProfile?.iqLevelIndex
        communicationIndex = JFSession.shared.myProfile?.communicationIndex
        personalityIndex = JFSession.shared.myProfile?.personalityIndex
        behaviorIndex = JFSession.shared.myProfile?.behaviorIndex
        cleanlinessIndex = JFSession.shared.myProfile?.cleanlinessIndex
        punctualityIndex = JFSession.shared.myProfile?.punctualityIndex
        appearanceIndex = JFSession.shared.myProfile?.appearanceIndex
        
        
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
                
                self?.friendlyIndex = JFIndexInfo(withJFIndex: userIndexData.trait1Average, jfMultiplier: nil, jfRateOfChange: userIndexData.trait1RateOfChange)
                self?.dressingIndex = JFIndexInfo(withJFIndex: userIndexData.trait2Average, jfMultiplier: nil, jfRateOfChange: userIndexData.trait2RateOfChange)
                self?.iqLevelIndex = JFIndexInfo(withJFIndex: userIndexData.trait3Average, jfMultiplier: nil, jfRateOfChange: userIndexData.trait3RateOfChange)
                self?.communicationIndex = JFIndexInfo(withJFIndex: userIndexData.trait4Average, jfMultiplier: nil, jfRateOfChange: userIndexData.trait4RateOfChange)
                self?.personalityIndex = JFIndexInfo(withJFIndex: userIndexData.trait5Average, jfMultiplier: nil, jfRateOfChange: userIndexData.trait5RateOfChange)
                self?.behaviorIndex = JFIndexInfo(withJFIndex: userIndexData.trait6Average, jfMultiplier: nil, jfRateOfChange: userIndexData.trait6RateOfChange)
                self?.cleanlinessIndex = JFIndexInfo(withJFIndex: userIndexData.trait7Average, jfMultiplier: nil, jfRateOfChange: userIndexData.trait7RateOfChange)
                self?.punctualityIndex = JFIndexInfo(withJFIndex: userIndexData.trait8Average, jfMultiplier: nil, jfRateOfChange: userIndexData.trait8RateOfChange)
                self?.appearanceIndex = JFIndexInfo(withJFIndex: userIndexData.trait9Average, jfMultiplier: nil, jfRateOfChange: userIndexData.trait9RateOfChange)
                
               
                // Graphdata manipulation
                guard let userGraphData = response.data?.graphUserData?.graphData else {return}
                let processingTimeString = userGraphData.last?.processingTime ?? ""
                let processingDate = Date(fromString: processingTimeString, format: DateFormatType.isoDateTimeMilliSec) ?? Date()
                
                let originprocessingTimeString = response.data?.graphUserData?.createdAt ?? ""
                let originProcessingDate = Date(fromString: originprocessingTimeString, format: DateFormatType.isoDateTimeMilliSec) ?? Date()
                
                let jfGraphDataPoint = userGraphData.compactMap({$0.jfim})
                
                let friendlyDataPoint = userGraphData.compactMap({$0.trait1Average})
                let dressingDataPoint = userGraphData.compactMap({$0.trait2Average})
                let iqLevelDataPoint = userGraphData.compactMap({$0.trait3Average})
                let communicationDataPoint = userGraphData.compactMap({$0.trait4Average})
                let personalityDataPoint = userGraphData.compactMap({$0.trait5Average})
                let behaviorDataPoint = userGraphData.compactMap({$0.trait6Average})
                let cleanlinessDataPoint = userGraphData.compactMap({$0.trait7Average})
                let punctualityDataPoint = userGraphData.compactMap({$0.trait8Average})
                let appearanceDataPoint = userGraphData.compactMap({$0.trait9Average})
                
                self?.jfIndex?.graphData = JFGraph(with: .jfIndex, data_points: jfGraphDataPoint, recent_processing_date: processingDate, origin_processing_date: originProcessingDate)

                self?.friendlyIndex?.graphData = JFGraph(with: .friendly, data_points: friendlyDataPoint, recent_processing_date: processingDate, origin_processing_date: originProcessingDate)
                self?.dressingIndex?.graphData = JFGraph(with: .dressing, data_points: dressingDataPoint, recent_processing_date: processingDate, origin_processing_date: originProcessingDate)
                self?.iqLevelIndex?.graphData = JFGraph(with: .iqLevel, data_points: iqLevelDataPoint, recent_processing_date: processingDate, origin_processing_date: originProcessingDate)
                self?.communicationIndex?.graphData = JFGraph(with: .communication, data_points: communicationDataPoint, recent_processing_date: processingDate, origin_processing_date: originProcessingDate)
                self?.personalityIndex?.graphData = JFGraph(with: .personality, data_points: personalityDataPoint, recent_processing_date: processingDate, origin_processing_date: originProcessingDate)
                self?.behaviorIndex?.graphData = JFGraph(with: .behavior, data_points: behaviorDataPoint, recent_processing_date: processingDate, origin_processing_date: originProcessingDate)
                self?.cleanlinessIndex?.graphData = JFGraph(with: .cleanliness, data_points: cleanlinessDataPoint, recent_processing_date: processingDate, origin_processing_date: originProcessingDate)
                self?.punctualityIndex?.graphData = JFGraph(with: .punctuality, data_points: punctualityDataPoint, recent_processing_date: processingDate, origin_processing_date: originProcessingDate)
                self?.appearanceIndex?.graphData = JFGraph(with: .appearance, data_points: appearanceDataPoint, recent_processing_date: processingDate, origin_processing_date: originProcessingDate)
                
                self?.graphLoaded = true
            }
            
            onCompletion?()
        }
    }
}
