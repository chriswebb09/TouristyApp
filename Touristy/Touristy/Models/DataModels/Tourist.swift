import UIKit
import Realm
import RealmSwift

class Tourist: Object {
    
    dynamic var tourPartyName: String = ""
    dynamic var tourType: String = ""
    dynamic var distanceTravelled: String = ""
    dynamic var triviaScore: Int = 0
    dynamic var pictureTaken: [Data] = [Data]()
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
    
    static func getPicturesFrom(data: Data) -> UIImage {
        return UIImage(data: data)!
    }
}
