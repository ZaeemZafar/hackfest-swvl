//
//  UserFilter.swift
//  Hackfest-swvl
//
//  Created by zaktech on 6/6/18.
//  Copyright © 2018 Citrusbits. All rights reserved.
//

import Foundation

class UserFilter {
    
    //MARK:- Public properties
    var filterActive: Bool
    var page: Int
    var limit: Int
    var search: String
    var distance: SelectedLocation
    var traitAppearance: Bool
    var traitIntelligence: Bool
    var traitPersonality: Bool
    var peopleWithAllRatingTypes: Bool
    var peopleAcceptingRating: Bool
    var peopleAcceptingAnonymousRating: Bool
    var peopleNotAcceptingRating: Bool
    var peopleRatedByMe: Bool
    var peopleInMyPortfolio: Bool
    var sort: SortFilter
    
    var indexMultipliers: [JFIndexMultiplierType] {
        var imArray = [JFIndexMultiplierType]()
        
        if self.traitAppearance {
            imArray.append(.appearance)
        }
        
        if self.traitPersonality {
            imArray.append(.personality)
        }
        
        if self.traitIntelligence {
            imArray.append(.intelligence)
        }
        
        return imArray
    }
    
    //MARK:- Init's
    init() {
        filterActive = false
        page = 0
        limit = 0
        search = ""
        distance = .miNone
        traitAppearance = false
        traitIntelligence = false
        traitPersonality = false
        peopleWithAllRatingTypes = false
        peopleAcceptingRating = false
        peopleAcceptingAnonymousRating = false
        peopleNotAcceptingRating = false
        peopleRatedByMe = false
        peopleInMyPortfolio = false
        sort = .none
    }
    
    func reset() {
        filterActive = false
        page = 0
        limit = 0
        search = ""
        distance = .miNone
        traitAppearance = false
        traitIntelligence = false
        traitPersonality = false
        peopleWithAllRatingTypes = false
        peopleAcceptingRating = false
        peopleAcceptingAnonymousRating = false
        peopleNotAcceptingRating = false
        peopleRatedByMe = false
        peopleInMyPortfolio = false
        sort = .none
    }
    
    func getCopy() -> UserFilter {
        let filter = UserFilter()
        filter.filterActive = filterActive
        filter.page = page
        filter.limit = limit
        filter.search = search
        filter.distance = distance
        filter.traitAppearance = traitAppearance
        filter.traitIntelligence = traitIntelligence
        filter.traitPersonality = traitPersonality
        filter.peopleWithAllRatingTypes = peopleWithAllRatingTypes
        filter.peopleAcceptingRating = peopleAcceptingRating
        filter.peopleAcceptingAnonymousRating = peopleAcceptingAnonymousRating
        filter.peopleNotAcceptingRating = peopleNotAcceptingRating
        filter.peopleRatedByMe = peopleRatedByMe
        filter.peopleInMyPortfolio = peopleInMyPortfolio
        filter.sort = sort
        return filter
    }
    
    func getParams(filter: UserFilter) -> [String: Any] {
        var params = [String: Any]()
        
        params["page"] = filter.page
        params["limit"] = filter.limit
        params["search"] = filter.search
        
        if filter.distance != .miNone {
            params["distance"] = filter.distance.rawValue
        }
        if filter.traitAppearance {
            params["traitAppearance"] = filter.traitAppearance
        }
        if filter.traitIntelligence {
            params["traitIntelligence"] = filter.traitIntelligence
        }
        if filter.traitPersonality {
            params["traitPersonality"] = filter.traitPersonality
        }
        if filter.peopleWithAllRatingTypes {
            //params["peopleWithAllRatingTypes"] = filter.peopleWithAllRatingTypes
        } else {
            if filter.peopleAcceptingRating {
                params["peopleAcceptingRating"] = filter.peopleAcceptingRating
            }
            if filter.peopleAcceptingAnonymousRating {
                params["peopleAcceptingAnonymousRating"] = filter.peopleAcceptingAnonymousRating
            }
            if filter.peopleNotAcceptingRating {
                params["peopleNotAcceptingRating"] = filter.peopleNotAcceptingRating
            }
        }
        if filter.peopleRatedByMe {
            params["peopleRatedByMe"] = filter.peopleRatedByMe
        }
        if filter.peopleInMyPortfolio {
            params["peopleInMyPortfolio"] = filter.peopleInMyPortfolio
        }
        if filter.sort != .none {
            params["sorting"] = filter.sort.stringValue
        }
        
        return params
    }
    
    func updateValue(type: FilterType) {
        switch type {
        case .location:
            break /////////////////////
            
        case .appearance:
            traitAppearance = !traitAppearance
        case .intelligence:
            traitIntelligence = !traitIntelligence
        case .personality:
            traitPersonality = !traitPersonality
            
        case .viewAll:
            peopleWithAllRatingTypes = !peopleWithAllRatingTypes
            peopleAcceptingRating = peopleWithAllRatingTypes
            peopleNotAcceptingRating = peopleWithAllRatingTypes
            peopleAcceptingAnonymousRating = peopleWithAllRatingTypes
            
        case .acceptingRatings:
            peopleAcceptingRating = !peopleAcceptingRating
            checkIfAllRatingsOn()
        case .notAcceptingRatings:
            peopleNotAcceptingRating = !peopleNotAcceptingRating
            checkIfAllRatingsOn()
        case .acceptingAnonymousRatings:
            peopleAcceptingAnonymousRating = !peopleAcceptingAnonymousRating
            checkIfAllRatingsOn()

        case .peopleIHaveRated:
            peopleRatedByMe = !peopleRatedByMe
        case .peopleInMyPortfolio:
            peopleInMyPortfolio = !peopleInMyPortfolio
            
        case .highToLow:
            sort = .highestToLowest
        case .lowToHigh:
            sort = .lowestToHighest
        case .aToZ:
            sort = .aToZ
        case .zToA:
            sort = .zToA
            
        default:
            break
        }
    }
    
    func getValue(type: FilterType) -> Bool {
        switch type {
        case .location:
            break /////////////////////
            
        case .appearance:
            return traitAppearance
        case .intelligence:
            return traitIntelligence
        case .personality:
            return traitPersonality
            
        case .viewAll:
            return peopleWithAllRatingTypes
        case .acceptingRatings:
            return peopleAcceptingRating
        case .notAcceptingRatings:
            return peopleNotAcceptingRating
        case .acceptingAnonymousRatings:
            return peopleAcceptingAnonymousRating
            
        case .peopleIHaveRated:
            return peopleRatedByMe
        case .peopleInMyPortfolio:
            return peopleInMyPortfolio
            
        case .highToLow:
            return (sort == .highestToLowest)
        case .lowToHigh:
            return (sort == .lowestToHighest)
        case .aToZ:
            return (sort == .aToZ)
        case .zToA:
            return (sort == .zToA)
            
        default:
            return false
        }
        return false
    }
    
    func getHeaderText() -> String {
        var textArray = [String]()
        
        var headerText = "Filter by "
        
        if distance != .miNone {
            textArray.append("Location (\(distance.rawValue) mi)")
        }
        
        if traitAppearance && traitPersonality && traitIntelligence {
            textArray.append("All Categories")
            
        } else {
            textArray.append(traitAppearance ? "Appearance" : "")
            textArray.append(traitPersonality ? "Personality" : "")
            textArray.append(traitIntelligence ? "Intelligence" : "")
        }
        
        if peopleWithAllRatingTypes {
            textArray.append("All Ratings")
        } else {
            textArray.append(peopleAcceptingRating ? "Accepting Ratings" : "")
            textArray.append(peopleNotAcceptingRating ? "Not Accepting Ratings" : "")
            textArray.append(peopleAcceptingAnonymousRating ? "Accepting Anonymous Ratings" : "")
        }
        
        if peopleRatedByMe {
            textArray.append("People I've Rated")
        }
        
        if peopleInMyPortfolio {
            textArray.append(peopleRatedByMe ? "In My Network" : "People In My Network")
        }
        
        textArray = textArray.filter { $0 != "" }
        
        if let sortText = sort.getHeaderText {
            if textArray.isEmpty {
                headerText = ""
            }
            textArray.append(sortText)
        }
        
        textArray = textArray.filter { $0 != "" }
        
        for (index, element) in textArray.enumerated() {
            if index == textArray.count - 1 {
                headerText += textArray.count > 1 ? "and \(element)." : "\(element)."
            } else {
                headerText += ((index + 1) == (textArray.count - 1)) ? "\(element) " : "\(element), "
            }
        }
        return headerText
    }
    
    func hasFiltersToApply() -> Bool {
        if distance != .miNone || traitAppearance || traitPersonality || traitIntelligence || peopleWithAllRatingTypes || peopleAcceptingRating || peopleAcceptingAnonymousRating || peopleNotAcceptingRating || peopleRatedByMe || peopleInMyPortfolio || sort != .none {
            
            return true
            
        } else {
            return false
        }
    }
    
    private func checkIfAllRatingsOn() {
        if peopleAcceptingRating && peopleNotAcceptingRating && peopleAcceptingAnonymousRating {
            peopleWithAllRatingTypes = true
            
        } else {
            peopleWithAllRatingTypes = false
        }
    }
}
