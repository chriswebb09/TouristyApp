import UIKit

public struct SplashViewModel {
    
    var splashImage: UIImage
    var animationDuration: Double
    
    init(splashImage: UIImage, animationDuration: Double) {
        self.splashImage = splashImage
        self.animationDuration = animationDuration
    }
}
