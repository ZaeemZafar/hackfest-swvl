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
    
    private var friendlyIndex: JFIndexInfo?
    private var dressingIndex: JFIndexInfo?
    private var iqLevelIndex: JFIndexInfo?
    private var communicationIndex: JFIndexInfo?
    private var personalityIndex: JFIndexInfo?
    private var behaviorIndex: JFIndexInfo?
    private var cleanlinessIndex: JFIndexInfo?
    private var punctualityIndex: JFIndexInfo?
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
        
        CategoryTypes.allCases.forEach { categoryType in
            ratings[categoryType] = [Int]()
        }
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
        
        profilePrivacy = (profileData.settings?.isPublicProfile ?? false) ? .publicProfile : .privateProfile
        acceptRating = profileData.settings?.acceptRating ?? false
        acceptAnonymousRating =  profileData.settings?.acceptAnonymousRating ?? false
        
        jfIndex = JFIndexInfo(withJFIndex: profileData.indexMultiplier?.jfIndex, jfMultiplier: profileData.indexMultiplier?.jfMultiplier, jfRateOfChange: profileData.indexMultiplier?.rateOfChange)
        
        
        friendlyIndex = JFIndexInfo(withJFIndex: profileData.indexMultiplier?.trait1Average, jfMultiplier: nil, jfRateOfChange: nil)
        dressingIndex = JFIndexInfo(withJFIndex: profileData.indexMultiplier?.trait2Average, jfMultiplier: nil, jfRateOfChange: nil)
        iqLevelIndex = JFIndexInfo(withJFIndex: profileData.indexMultiplier?.trait3Average, jfMultiplier: nil, jfRateOfChange: nil)
        communicationIndex = JFIndexInfo(withJFIndex: profileData.indexMultiplier?.trait4Average, jfMultiplier: nil, jfRateOfChange: nil)
        personalityIndex = JFIndexInfo(withJFIndex: profileData.indexMultiplier?.trait5Average, jfMultiplier: nil, jfRateOfChange: nil)
        behaviorIndex = JFIndexInfo(withJFIndex: profileData.indexMultiplier?.trait6Average, jfMultiplier: nil, jfRateOfChange: nil)
        cleanlinessIndex = JFIndexInfo(withJFIndex: profileData.indexMultiplier?.trait7Average, jfMultiplier: nil, jfRateOfChange: nil)
        punctualityIndex = JFIndexInfo(withJFIndex: profileData.indexMultiplier?.trait8Average, jfMultiplier: nil, jfRateOfChange: nil)
        appearanceIndex = JFIndexInfo(withJFIndex: profileData.indexMultiplier?.trait9Average, jfMultiplier: nil, jfRateOfChange: nil)
        
        followingState = profileData.followingRelation != nil ? ((profileData.followingRelation?.acceptRequest ?? false) ? .following : .requested) : FollowingStatus.none
        followedByState = profileData.followedByRelation != nil ? ((profileData.followedByRelation?.acceptRequest ?? false) ? .following : .requested) : FollowingStatus.none
        
        ratingsGiven = profileData.multiplierInfo?.ratingsGiven ?? 0
        ratingsReceived = profileData.multiplierInfo?.ratingsReceived ?? 0
        
        trait[.friendly] = profileData.settings?.trait1 ?? false
        trait[.dressing] = profileData.settings?.trait2 ?? false
        trait[.iqLevel] = profileData.settings?.trait3 ?? false
        trait[.communication] = profileData.settings?.trait4 ?? false
        trait[.personality] = profileData.settings?.trait5 ?? false
        trait[.behavior] = profileData.settings?.trait6 ?? false
        trait[.cleanliness] = profileData.settings?.trait7 ?? false
        trait[.punctuality] = profileData.settings?.trait8 ?? false
        trait[.appearance] = profileData.settings?.trait9 ?? false
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
        profilePrivacy = (profileData.settings?.isPublicProfile ?? false) ? .publicProfile : .privateProfile
        imagePath = profileData.image
        locationLongitude = profileData.longitude
        locationLatitude = profileData.latitude
        
        ratingsGiven = profileData.multiplierInfo?.ratingsGiven ?? 0
        ratingsReceived = profileData.multiplierInfo?.ratingsReceived ?? 0
        
        jfIndex = JFIndexInfo(withJFIndex: profileData.indexMultiplier?.jfIndex, jfMultiplier: profileData.indexMultiplier?.jfMultiplier, jfRateOfChange: profileData.indexMultiplier?.rateOfChange)
        
        acceptRating = profileData.settings?.acceptRating ?? false
        acceptAnonymousRating =  profileData.settings?.acceptAnonymousRating ?? false
        
        displayFacebookProfileLink = profileData.settings?.displayFacebookProfile ?? false
        
        followingState = profileData.followingRelation != nil ? ((profileData.followingRelation?.acceptRequest ?? false) ? .following : .requested) : FollowingStatus.none
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
        
        
        
        trait[.friendly] = profileData.settings?.trait1 ?? false
        trait[.dressing] = profileData.settings?.trait2 ?? false
        trait[.iqLevel] = profileData.settings?.trait3 ?? false
        trait[.communication] = profileData.settings?.trait4 ?? false
        trait[.personality] = profileData.settings?.trait5 ?? false
        trait[.behavior] = profileData.settings?.trait6 ?? false
        trait[.cleanliness] = profileData.settings?.trait7 ?? false
        trait[.punctuality] = profileData.settings?.trait8 ?? false
        trait[.appearance] = profileData.settings?.trait9 ?? false
        
        if let ratingData = profileData.rateButtonInfo {
            // isAnonymous: Previous rate status
            // count: not needed at the moment
            if let dateTimeString = ratingData.lastActionTime {
                lastRatingDate = Date(fromString: dateTimeString, format: DateFormatType.isoDateTimeMilliSec)
            }
            
            
            ratings[.friendly] = ratingData.trait1 ?? []
            ratings[.dressing] = ratingData.trait2 ?? []
            ratings[.iqLevel] = ratingData.trait3 ?? []
            ratings[.communication] = ratingData.trait4 ?? []
            ratings[.personality] = ratingData.trait5 ?? []
            ratings[.behavior] = ratingData.trait6 ?? []
            ratings[.cleanliness] = ratingData.trait7 ?? []
            ratings[.punctuality] = ratingData.trait8 ?? []
            ratings[.appearance] = ratingData.trait9 ?? []

            
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
        profilePrivacy = (profileData?.settings?.isPublicProfile ?? false) ? .publicProfile : .privateProfile
        imagePath = profileData?.image ?? ""
    }
    
    convenience init(userID: String?, first_name: String?, last_name: String?, isPublicProfile: Bool = false, image_path: String?) {
        self.init()
        
        id = userID ?? ""
        firstName = first_name ?? ""
        lastName = last_name ?? ""
        profilePrivacy = isPublicProfile ? .publicProfile : .privateProfile
        imagePath = image_path
    }
    
    convenience init(profileData: ExistingUsers?) {
        self.init()
        
        id = "\(profileData?.id ?? 0)"
        firstName = profileData?.firstName ?? ""
        lastName = profileData?.lastName ?? ""
        imagePath = profileData?.image
        phone = profileData?.phoneNumber ?? ""
        
        profilePrivacy = (profileData?.settings?.isPublicProfile ?? false) ? .publicProfile : .privateProfile
        acceptRating = profileData?.settings?.acceptRating ?? false
        acceptAnonymousRating =  profileData?.settings?.acceptAnonymousRating ?? false
        
        followingState = profileData?.followingRelation != nil ? ((profileData?.followingRelation?.acceptRequest ?? false) ? .following : .requested) : FollowingStatus.none
        
        jfIndex = JFIndexInfo(withJFIndex: profileData?.indexMultiplier?.jfIndex, jfMultiplier: profileData?.indexMultiplier?.jfMultiplier, jfRateOfChange: profileData?.indexMultiplier?.rateOfChange)
    }
}

//MARK:- Graph data
extension JFProfile {
    
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
    
    var graphData: [JFGraph] {
        var graphArray = [JFGraph?]()
        graphArray.append(jfIndex?.graphData)
        
        if trait[.friendly] ?? false {
            graphArray.append(friendlyIndex?.graphData)
            
        }
        if trait[.dressing] ?? false {
            graphArray.append(dressingIndex?.graphData)
            
        }
        if trait[.iqLevel] ?? false {
            graphArray.append(iqLevelIndex?.graphData)
            
        }
        if trait[.communication] ?? false {
            graphArray.append(communicationIndex?.graphData)
            
        }
        if trait[.personality] ?? false {
            graphArray.append(personalityIndex?.graphData)
            
        }
        if trait[.behavior] ?? false {
            graphArray.append(behaviorIndex?.graphData)
            
        }
        if trait[.cleanliness] ?? false {
            graphArray.append(cleanlinessIndex?.graphData)
            
        }
        if trait[.punctuality] ?? false {
            graphArray.append(punctualityIndex?.graphData)
            
        }
        if trait[.appearance] ?? false {
            graphArray.append(appearanceIndex?.graphData)
            
        }
        
        return graphArray.compactMap({$0})
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
                
                
                let friendlyDataPoints = userGraphData.compactMap({$0.trait1Average})
                let dressingDataPoints = userGraphData.compactMap({$0.trait2Average})
                let iqLevelDataPoints = userGraphData.compactMap({$0.trait3Average})
                let communicationDataPoints = userGraphData.compactMap({$0.trait4Average})
                let personalityDataPoints = userGraphData.compactMap({$0.trait5Average})
                let behaviorDataPoints = userGraphData.compactMap({$0.trait6Average})
                let cleanlinessDataPoints = userGraphData.compactMap({$0.trait7Average})
                let punctualityDataPoints = userGraphData.compactMap({$0.trait8Average})
                let appearanceDataPoints = userGraphData.compactMap({$0.trait9Average})
                
                
                self?.jfIndex?.graphData = JFGraph(with: .jfIndex, data_points: jfGraphDataPoint, recent_processing_date: processingDate, origin_processing_date: originProcessingDate)
                
                
                self?.friendlyIndex?.graphData = JFGraph(with: .friendly, data_points: friendlyDataPoints, recent_processing_date: processingDate, origin_processing_date: originProcessingDate)
                self?.dressingIndex?.graphData = JFGraph(with: .dressing, data_points: dressingDataPoints, recent_processing_date: processingDate, origin_processing_date: originProcessingDate)
                self?.iqLevelIndex?.graphData = JFGraph(with: .iqLevel, data_points: iqLevelDataPoints, recent_processing_date: processingDate, origin_processing_date: originProcessingDate)
                self?.communicationIndex?.graphData = JFGraph(with: .communication, data_points: communicationDataPoints, recent_processing_date: processingDate, origin_processing_date: originProcessingDate)
                self?.personalityIndex?.graphData = JFGraph(with: .personality, data_points: personalityDataPoints, recent_processing_date: processingDate, origin_processing_date: originProcessingDate)
                self?.behaviorIndex?.graphData = JFGraph(with: .behavior, data_points: behaviorDataPoints, recent_processing_date: processingDate, origin_processing_date: originProcessingDate)
                self?.cleanlinessIndex?.graphData = JFGraph(with: .cleanliness, data_points: cleanlinessDataPoints, recent_processing_date: processingDate, origin_processing_date: originProcessingDate)
                self?.punctualityIndex?.graphData = JFGraph(with: .punctuality, data_points: punctualityDataPoints, recent_processing_date: processingDate, origin_processing_date: originProcessingDate)
                self?.appearanceIndex?.graphData = JFGraph(with: .appearance, data_points: appearanceDataPoints, recent_processing_date: processingDate, origin_processing_date: originProcessingDate)
                
                
            }
            
            self?.graphLoaded = true
            onCompletion?()
        }
    }
}
