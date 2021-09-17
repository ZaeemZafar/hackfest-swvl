/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

enum JFPushNotificationType: String, Codable {
    case ratingRequested, userRated, anonymousRated, inviteAccepted, ratingRequestedAgain, followRequest, undefined = ""

}

import Foundation
struct NotificationData : Codable {
	let id : Int?
	let userId : Int?
	let fromUserId : Int?
	let isSeen : Bool?
	let jfIndex : Double?
	let jfMultiplier : Double?
	let notificationDetail : NotificationDetail?
    
    private let createdAt : String?
    private let notificationFrom : NotificationFrom?
    private let notificationTypeString : String?
    
    var type: JFPushNotificationType = .anonymousRated
    
    var senderInfo : JFProfile? {
        get {
            return JFProfile(profileData: notificationFrom)
        }
    }
    
    var createdDate: Date? {
        get {
            return Date(fromString: createdAt ?? "", format: .isoDateTimeMilliSec)
        }
    }

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case userId = "userId"
		case fromUserId = "fromUserId"
		case notificationTypeString = "notificationType"
		case isSeen = "isSeen"
		case jfIndex = "jfIndex"
		case jfMultiplier = "jfMultiplier"
		case createdAt = "createdAt"
		case notificationFrom = "notificationFrom"
		case notificationDetail = "notificationDetail"
        case type = ""
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		userId = try values.decodeIfPresent(Int.self, forKey: .userId)
		fromUserId = try values.decodeIfPresent(Int.self, forKey: .fromUserId)
		notificationTypeString = try values.decodeIfPresent(String.self, forKey: .notificationTypeString)
        type = JFPushNotificationType(rawValue: notificationTypeString ?? "userRated") ?? .userRated
		isSeen = try values.decodeIfPresent(Bool.self, forKey: .isSeen)
		jfIndex = try values.decodeIfPresent(Double.self, forKey: .jfIndex)
		jfMultiplier = try values.decodeIfPresent(Double.self, forKey: .jfMultiplier)
		createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        
        do {
            notificationFrom = try values.decodeIfPresent(NotificationFrom.self, forKey: .notificationFrom)
        } catch {notificationFrom = nil}
        
        do {
            notificationDetail = try values.decodeIfPresent(NotificationDetail.self, forKey: .notificationDetail)
        } catch {notificationDetail = nil}
        
	}

}
