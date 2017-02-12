import UIKit


public struct Constants {
    
    public struct Font {
        public static let fontNormal = UIFont(name: "HelveticaNeue-Light", size: 18)
        public static let fontSmall = UIFont(name: "HelveticaNeue-Light", size: 12)
        public static let fontMedium = UIFont(name: "HelveticaNeue-Light", size: 16)
        public static let fontLarge = UIFont(name: "HelveticaNeue-Thin", size: 22)
        public static let bolderFontSmall = UIFont(name: "HelveticaNeue", size: 12)
        public static let bolderFontMediumSmall = UIFont(name: "HelveticaNeue", size: 14)
        public static let bolderFontMedium = UIFont(name: "HelveticaNeue", size: 16)
        public static let bolderFontMediumLarge = UIFont(name: "HelveticaNeue", size: 20)
        public static let bolderFontLarge = UIFont(name: "HelveticaNeue", size: 22)
        public static let bolderFontNormal = UIFont(name: "HelveticaNeue", size: 18)
    }
    
    public struct Color {
        public static let mainColor = UIColor(red:0.41, green:0.72, blue:0.90, alpha:1.0)
        public static let backgroundColor = UIColor(red:0.21, green:0.22, blue:0.24, alpha:1.0)
        public static let buttonColor = UIColor(red:0.10, green:0.71, blue:1.00, alpha:1.0)
        public static let tableViewBackgroundColor = UIColor(red:0.92, green:0.92, blue:0.92, alpha:1.0)
    }
    
    public struct Login {
        public static let loginSuccessColor = UIColor(red:0.41, green:0.72, blue:0.90, alpha:1.0)
        // public static let loginFieldHeight = CGFloat(0.07)
        public static let loginFieldHeight = CGFloat(0.075)
        public static let loginFieldEditColor: UIColor = UIColor(red:0.21, green:0.22, blue:0.24, alpha:1.0)
        public static let loginFieldEditBorderColor: CGColor = UIColor(red:0.21, green:0.22, blue:0.24, alpha:1.0).cgColor
        public static let loginFieldWidth = CGFloat(0.85)
        public static let loginButtonWidth = CGFloat(0.6)
        public static let loginButtonColor = UIColor(red:0.41, green:0.72, blue:0.90, alpha:1.0)
        public static let loginLogoTopSpacing:CGFloat =  0.045
        public static let loginElementSpacing:CGFloat =  0.07
        public static let loginSignupElementSpacing:CGFloat =  0.035
        public static let dividerHeight: CGFloat = 0.02
        public static let dividerWidth: CGFloat = 0.9
        public static let registerLabelColor = UIColor(red:0.21, green:0.22, blue:0.24, alpha:1.0)
        public static let signupButtonColor = UIColor(red:0.21, green:0.22, blue:0.24, alpha:1.0)
    }
}
