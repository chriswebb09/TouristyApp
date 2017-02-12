//
//  FirebaseAPIClient.swift
//  Touristy
//
//  Created by Christopher Webb-Orenstein on 2/12/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit
import Firebase

struct FirebaseAPIClient {
    var ref: FIRDatabaseReference!
    var refHandle: FIRDatabaseHandle!
    var dataSnapshot = [FIRDataSnapshot]()
}
