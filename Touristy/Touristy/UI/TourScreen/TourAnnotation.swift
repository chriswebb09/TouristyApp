import UIKit
import Mapbox

class Annotation: MGLPointAnnotation {
    
    enum AnnotationType {
        case origin, POI, tourStop, error
    }
    
    var type: AnnotationType
    
    init(typeSelected: AnnotationType) {
        self.type = typeSelected
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.type = .tourStop
        fatalError("init(coder:) has not been implemented")
    }
    
    var annotationColor: UIColor {
        switch type {
        case .origin:
            return .purple
        case .tourStop:
            return .red
        case .POI:
            return .blue
        default:
            return .lightGray
        }
    }
}
