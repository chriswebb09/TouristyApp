import UIKit
import Mapbox

class TourSpotAnnotationView: MGLAnnotationView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        scalesWithViewingDistance = false
        backgroundColor = .white
        layer.cornerRadius = frame.width / 2
        layer.borderWidth = 4
        layer.borderColor = UIColor.babyBlueColor().cgColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        let animation = CABasicAnimation(keyPath: "borderWidth")
        animation.duration = 0.1
        
        layer.borderWidth = selected ? frame.width / 4 : 2
        layer.add(animation, forKey: "borderWidth")
    }
}
