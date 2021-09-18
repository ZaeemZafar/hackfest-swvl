//
//  JFProfile.swift
//  Hackfest-swvl
//
//  Created by zaktech on 5/23/18.
//  Copyright © 2018 maskers. All rights reserved.
//

import Foundation
import CoreLocation

enum FollowingStatus: Int, Codable {
    case following = 0, requested, none
}

class JFProfile: Hashable, Equatable {
    
    //MARK:- Private properties
    private var displayFacebookProfileLink: Bool
    private var locationLatitude: CLLocationDegrees?
    private var locationLongitude: CLLocationDegrees?
    private var jfIndex: JFIndexInfo?
    private var intelligenceIndex: JFIndexInfo?
    private var personalityIndex: JFIndexInfo?
    private var appearanceIndex: JFIndexInfo?
    
    //MARK:- Public properties
    var id: String
    var firstName: String
    var lastName: String
    var facebookId: String
    var fbProfileLink: String
    var email: String
    var phone: String
    var profilePrivacy: ProfilePrivacyLevel
    var imagePath: String?
    
    var acceptRating: Bool
    var acceptAnonymousRating : Bool
    var ratingsGiven : Int
    var ratingsReceived : Int
    
    var followingState: FollowingStatus
    var followedByState: FollowingStatus
    var blockedByMe: Bool
    var blockedByThem: Bool
    
    var trait: [Trait: Bool]
    var ratings = [CategoryTypes: [Int]]()
    
    var address: String
    var bio:String
    
    var lastRatingDate: Date?
    var lastRateRequestedOnDate: Date?
    
    var graphLoaded = false
    
    // Implementing Equatable
    var hashValue: Int { get { return id.hashValue } }
    
    static func ==(left:JFProfile, right:JFProfile) -> Bool {
        return left.id == right.id
    }
    
    //MARK:- Computed properties
    var displayFBProfileLink: Bool {
        get {
            
            // Developer Note:
            // TODO:
            // For testing purposes only
            if JFConstants.facebookDisabled {
                return false
                
            } else {
                return displayFacebookProfileLink
            }
            
        }
    }
    var fullName: String {
        get {
            return firstName + " " + lastName
        }
    }
    var isMyProfile: Bool {
        get {
            return self.id == JFSession.shared.myProfile?.id
        }
    }
    var hasBeenRated: Bool {
        get {
            return lastRatingDate != nil
        }
    }
    var hasBeenRequested: Bool {
        get {
            return lastRateRequestedOnDate != nil
        }
    }
    var canRateAgain: Bool {
        if let rateDate = lastRatingDate {
            return Date().timeIntervalSince(rateDate) > JFAppTarget.current.secondsLimitForNextOperation
        } else {
            return true
        }
    }
    var canRequestAgain: Bool {
        if let ratingRequestDate = lastRateRequestedOnDate {
            return Date().timeIntervalSince(ratingRequestDate) > JFAppTarget.current.secondsLimitForNextOperation
        } else {
            return true
        }
    }
    var secondsToRateAgain: TimeInterval {
        if let lastRateDate = lastRatingDate {
            return JFAppTarget.current.secondsLimitForNextOperation - Date().timeIntervalSince(lastRateDate)
        } else {
            return 0
        }
    }
    var secondsToRequestAgain: TimeInterval {
        if let ratingRequestDate = lastRateRequestedOnDate {
            return JFAppTarget.current.secondsLimitForNextOperation - Date().timeIntervalSince(ratingRequestDate)
        } else {
            return 0
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
    func imageURL(thumbnail: Bool = false) -> URL? {
        let imageBaseURL = thumbnail ? JFConstants.s3ThumbnailImageURL : JFConstants.s3ImageURL
        let urlString =  imageBaseURL + (imagePath ?? "")
        return URL(string: urlString)
    }
    
    required init() {
        id                  = ""
        firstName           = ""
        lastName            = ""
        facebookId          = ""
        fbProfileLink       = ""
        email               = ""
        phone               = ""
        profilePrivacy      = .publicProfile
        imagePath = ""
        
        acceptRating = false
        acceptAnonymousRating = false
        displayFacebookProfileLink = false
        ratingsGiven = 0
        ratingsReceived = 0
        followingState = .none
        followedByState = .none
        blockedByMe = false
        blockedByThem = false
        
        trait = [Trait: Bool]()
        address = ""
        bio = ""
        locationLatitude = nil
        locationLongitude = nil
        
        ratings[.appearance] = [Int]()
        ratings[.intelligence] = [Int]()
        ratings[.personality] = [Int]()
    }
}

//MARK:- Convienience initializers
extension JFProfile {
    
    convenience init(profileData: NetworkData) {
        self.init()
        
        id = "\(profileData.id ?? 0)"
        firstName = profileData.firstName ?? ""
        lastName = profileData.lastName ?? ""
        imagePath = profileData.image
        
        profilePrivacy = (profileData.settings?.isCaptainProfile ?? false) ? .publicProfile : .privateProfile
        acceptRating = profileData.settings?.acceptRating ?? false
        acceptAnonymousRating =  profileData.settings?.acceptAnonymousRating ?? false
        
        jfIndex = JFIndexInfo(withJFIndex: profileData.indexMultiplier?.jfIndex, jfMultiplier: profileData.indexMultiplier?.jfMultiplier, jfRateOfChange: profileData.indexMultiplier?.rateOfChange)
        
        appearanceIndex = JFIndexInfo(withJFIndex: profileData.indexMultiplier?.appearanceAverage, jfMultiplier: nil, jfRateOfChange: nil)
        intelligenceIndex = JFIndexInfo(withJFIndex: profileData.indexMultiplier?.intelligenceAverage, jfMultiplier: nil, jfRateOfChange: nil)
        personalityIndex = JFIndexInfo(withJFIndex: profileData.indexMultiplier?.personalityAverage, jfMultiplier: nil, jfRateOfChange: nil)
        
        followingState = profileData.friendRelation != nil ? ((profileData.friendRelation?.acceptRequest ?? false) ? .following : .requested) : FollowingStatus.none
        followedByState = profileData.followedByRelation != nil ? ((profileData.followedByRelation?.acceptRequest ?? false) ? .following : .requested) : FollowingStatus.none
        
        ratingsGiven = profileData.multiplierInfo?.ratingsGiven ?? 0
        ratingsReceived = profileData.multiplierInfo?.ratingsReceived ?? 0
        
        trait[.intelligence] = profileData.settings?.traitIntelligence ?? false
        trait[.appearance] = profileData.settings?.traitAppearance ?? false
        trait[.personality] = profileData.settings?.traitPersonality ?? false
        trait[.none] = profileData.settings?.traitNone ?? false
    }
    
    convenience init(profileData: NetworkProfileAPIResponse, graphDataRetrieved: SimpleCompletionBlock?) {
        self.init()
        
        id = "\(profileData.id ?? 0)"
        address = profileData.location ?? ""
        bio = profileData.biography ?? ""
        firstName = profileData.firstName ?? ""
        lastName = profileData.lastName ?? ""
        facebookId = profileData.facebookId ?? ""
        fbProfileLink = profileData.fbProfileLink ?? ""
        profilePrivacy = (profileData.settings?.isCaptainProfile ?? false) ? .publicProfile : .privateProfile
        imagePath = profileData.image
        locationLongitude = profileData.longitude
        locationLatitude = profileData.latitude
        
        ratingsGiven = profileData.multiplierInfo?.ratingsGiven ?? 0
        ratingsReceived = profileData.multiplierInfo?.ratingsReceived ?? 0
        
        jfIndex = JFIndexInfo(withJFIndex: profileData.indexMultiplier?.jfIndex, jfMultiplier: profileData.indexMultiplier?.jfMultiplier, jfRateOfChange: profileData.indexMultiplier?.rateOfChange)
        
        acceptRating = profileData.settings?.acceptRating ?? false
        acceptAnonymousRating =  profileData.settings?.acceptAnonymousRating ?? false
        
        displayFacebookProfileLink = profileData.settings?.displayFacebookProfile ?? false
        
        followingState = profileData.friendRelation != nil ? ((profileData.friendRelation?.acceptRequest ?? false) ? .following : .requested) : FollowingStatus.none
        followedByState = profileData.followedByRelation != nil ? ((profileData.followedByRelation?.acceptRequest ?? false) ? .following : .requested) : FollowingStatus.none
        
        if profileData.blockedByMe != nil && profileData.blockedByThem != nil {
            blockedByThem = true
            blockedByMe = true
            
        } else if profileData.blockedByMe != nil {
            blockedByThem = false
            blockedByMe = true
            
        } else if profileData.blockedByThem != nil {
            blockedByThem = true
            blockedByMe = false
        }
        
        trait[.intelligence] = profileData.settings?.traitIntelligence ?? false
        trait[.appearance] = profileData.settings?.traitAppearance ?? false
        trait[.personality] = profileData.settings?.traitPersonality ?? false
        trait[.none] = profileData.settings?.traitNone ?? false
        
        if let ratingData = profileData.rateButtonInfo {
            // isAnonymous: Previous rate status
            // count: not needed at the moment
            if let dateTimeString = ratingData.lastActionTime {
                lastRatingDate = Date(fromString: dateTimeString, format: DateFormatType.isoDateTimeMilliSec)
            }
            
            ratings[.appearance] = ratingData.traitAppearance ?? [Int]()
            ratings[.intelligence] = ratingData.traitIntelligence ?? [Int]()
            ratings[.personality] = ratingData.traitPersonality ?? [Int]()
            
        } else {
            // Normal rating scenarios
        }
        
        if let requestRatingInfo = profileData.requestButtonInfo {
            // isAnonymous: Previous rate status
            // count: not needed at the moment
            if let dateTimeString = requestRatingInfo.lastActionTime {
                lastRateRequestedOnDate = Date(fromString: dateTimeString, format: DateFormatType.isoDateTimeMilliSec)
            }
            
        } else {
            // Normal request rating scenarios
        }
        
        if acceptRating {
            
            if profilePrivacy == .publicProfile || followingState == .following {
                updateGraphData(onCompletion: graphDataRetrieved)
            }
        }
    }
    
    convenience init(profileData: NotificationFrom?) {
        self.init()
        
        id = "\(profileData?.id ?? 0)"
        firstName = profileData?.firstName ?? ""
        lastName = profileData?.lastName ?? ""
        profilePrivacy = (profileData?.settings?.isCaptainProfile ?? false) ? .publicProfile : .privateProfile
        imagePath = profileData?.image ?? ""
    }
    
    convenience init(userID: String?, first_name: String?, last_name: String?, isCaptainProfile: Bool = false, image_path: String?) {
        self.init()
        
        id = userID ?? ""
        firstName = first_name ?? ""
        lastName = last_name ?? ""
        profilePrivacy = isCaptainProfile ? .publicProfile : .privateProfile
        imagePath = image_path
    }
    
    convenience init(profileData: ExistingUsers?) {
        self.init()
        
        id = "\(profileData?.id ?? 0)"
        firstName = profileData?.firstName ?? ""
        lastName = profileData?.lastName ?? ""
        imagePath = profileData?.image
        phone = profileData?.phoneNumber ?? ""
        
        profilePrivacy = (profileData?.settings?.isCaptainProfile ?? false) ? .publicProfile : .privateProfile
        acceptRating = profileData?.settings?.acceptRating ?? false
        acceptAnonymousRating =  profileData?.settings?.acceptAnonymousRating ?? false
        
        followingState = profileData?.friendRelation != nil ? ((profileData?.friendRelation?.acceptRequest ?? false) ? .following : .requested) : FollowingStatus.none
        
        jfIndex = JFIndexInfo(withJFIndex: profileData?.indexMultiplier?.jfIndex, jfMultiplier: profileData?.indexMultiplier?.jfMultiplier, jfRateOfChange: profileData?.indexMultiplier?.rateOfChange)
    }
}

//MARK:- Graph data
extension JFProfile {
    
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
    
    var graphData: [JFGraph] {
        var graphArray = [JFGraph?]()
        graphArray.append(jfIndex?.graphData)
        
        if trait[.appearance] ?? false {
            graphArray.append(appearanceIndex?.graphData)
        }
        
        if trait[.personality] ?? false {
            graphArray.append(personalityIndex?.graphData)
        }
        
        if trait[.intelligence] ?? false {
            graphArray.append(intelligenceIndex?.graphData)
        }
        
        return graphArray.compactMap({$0})
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
                
            }
            
            self?.graphLoaded = true
            onCompletion?()
        }
    }
}
