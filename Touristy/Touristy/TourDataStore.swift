import UIKit

class TourDataStore {
    
    static let shared = TourDataStore()
    
    var tour: Tourist
    
    init() {
        self.tour = Tourist(tourPartyName: "UnNamed", tourType: "History", distanceTravelled: "1345", triviaScore: 0, pictureTaken: nil, levelOfActivity: "Strenous", distanceToTravel: "More")
    }
    
    init(tourist: Tourist) {
        self.tour = tourist
    }
    
}
