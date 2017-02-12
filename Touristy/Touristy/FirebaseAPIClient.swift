import UIKit
import Firebase

struct FirebaseAPIClient {
    var ref: FIRDatabaseReference!
    var refHandle: FIRDatabaseHandle!
    var dataSnapshot = [FIRDataSnapshot]()
}
