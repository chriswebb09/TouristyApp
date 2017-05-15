//
//  Queries.swift
//  Touristy
//
//  Created by Christopher Webb-Orenstein on 5/14/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import Foundation

struct Queries {
    var queryOne = Query(points: 5, questionText: "Are you feeling energetic?", result: false)
    var queryTwo = Query(points: 5, questionText: "Ready to get old-timey?", result: false)
    var queryThree = Query(points: 5, questionText: "Patriotic or nah?", result: false)
    var questionList: [Query]
    init() {
        self.questionList = [queryOne, queryTwo, queryThree]
    }
}
