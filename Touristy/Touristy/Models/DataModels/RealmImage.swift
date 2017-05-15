//
//  RealmImage.swift
//  Touristy
//
//  Created by Christopher Webb-Orenstein on 5/14/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class RealmImage: Object {
    
    dynamic var image: Data = Data()
    
    required init() {
        super.init()
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
    init(image: Data) {
        self.image = image
        super.init()
    }
}
