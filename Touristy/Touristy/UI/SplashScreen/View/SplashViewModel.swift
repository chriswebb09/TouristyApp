import UIKit

public struct SplashViewModel {
    
    var splashImage: UIImage
    var animationDuration: Double
    
    init(image: UIImage, duration: Double) {
        splashImage = image
        self.animationDuration = duration
    }
}
