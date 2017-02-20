import UIKit

struct Query {
    var points: Int
    var questionText: String
    var result: Bool
}

struct Queries {
    var queryOne = Query(points: 5, questionText: "Are you feeling energetic?", result: false)
    var queryTwo = Query(points: 5, questionText: "Ready to get old-timey?", result: false)
    var queryThree = Query(points: 5, questionText: "Patriotic or nah?", result: false)
    var questionList: [Query]
    init() {
        self.questionList = [queryOne, queryTwo, queryThree]
    }
}
