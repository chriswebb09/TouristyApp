import UIKit
import Realm
import RealmSwift


class RealmImage: Object {
    required init() {
        super.init()
    }
    
    required init(value: Any, schema: RLMSchema) {
        fatalError("init(value:schema:) has not been implemented")
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        fatalError("init(realm:schema:) has not been implemented")
    }
}

class Tourist: Object {
    dynamic var username: String = ""
    dynamic var emailAddress: String = ""
    dynamic var uuid: String = ""
    dynamic var tourPartyName: String = ""
    dynamic var tourType: String = ""
    dynamic var distanceTravelled: String = ""
    dynamic var triviaScore: Int = 0
    var picturesTaken: List<RealmImage> = List()
    dynamic var levelOfActivity: String = ""
    dynamic var distanceToTravel: String = ""
    
    required init() {
        super.init()
    }
    
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
    init(username: String, emailAddress: String, uuid: String, tourPartyName: String,
         tourType: String, distanceTravelled: String, triviaScore: Int, picturesTaken: List<RealmImage>,
         levelOfActivity: String, distanceToTravel: String) {
        self.username = username
        self.emailAddress = emailAddress
        self.uuid = uuid
        self.tourPartyName = tourPartyName
        self.tourType = tourType
        self.distanceToTravel = distanceToTravel
        self.triviaScore = triviaScore
        self.picturesTaken = picturesTaken
        self.levelOfActivity = levelOfActivity
        self.distanceToTravel = distanceToTravel
        super.init()
    }
    
    static func getPicturesFrom(data: Data) -> UIImage {
        return UIImage(data: data)!
    }
}
