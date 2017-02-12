import UIKit

class AppScreenView: UIView {
    
    var viewModel: AppScreenViewModel = {
        return AppScreenViewModel()
    }()
    
    var logoImageView: UIImageView = {
        let image = UIImage(named: "mapboxlogo2")
        let imageView = UIImageView(image: image)
        return imageView
    }()
    
    var loginButton: UIButton = {
        let button = ButtonType.login(title: "New Tour")
        return button.newButton
    }()
    
    var signupButton: UIButton = {
        let button = ButtonType.system(title:"Stats", color: .darkGray).newButton
        button.backgroundColor = UIColor(red:1.00, green:0.50, blue:0.04, alpha:1.0)
        return button
    }()
    
    var viewDivider: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = UIColor(red:0.30, green:0.40, blue:0.50, alpha:1.0)
        frame = UIScreen.main.bounds
        setupConstraints()
    }
}

extension AppScreenView {
    
    fileprivate func setupConstraints() {
        setupLogoImage(logoImageView: logoImageView)
        constraintSetup(views: [viewDivider, loginButton, signupButton])
        setupViewDivider(viewDivider: viewDivider)
        
        loginButton.bottomAnchor.constraint(equalTo: viewDivider.topAnchor, constant: UIScreen.main.bounds.height * 0.18).isActive = true
        loginButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: Constants.Login.loginFieldWidth).isActive = true
        loginButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier:0.085).isActive = true
        loginButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        signupButton.topAnchor.constraint(equalTo: viewDivider.bottomAnchor, constant: UIScreen.main.bounds.height * 0.05).isActive = true
        signupButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: Constants.Login.loginFieldWidth).isActive = true
        signupButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier:0.075).isActive = true
        signupButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        signupButton.isHidden = true
    }
    
    private func setupLogoImage(logoImageView: UIView) {
        addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.78).isActive = true
        logoImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.42).isActive = true
        logoImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        logoImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: bounds.height * -0.1).isActive = true
    }
    
    func buttonSetup(buttons: [UIButton]) {
        // Not implemented yet
    }
    
    private func constraintSetup(views: [UIView]) {
        _ = views.map { addSubview($0) }
        _ = views.map { $0.translatesAutoresizingMaskIntoConstraints = false }
    }
    
    private func setupView(view: UIView) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalTo: widthAnchor, multiplier: Constants.Login.loginFieldWidth).isActive = true
        view.heightAnchor.constraint(equalTo: heightAnchor, multiplier:Constants.Login.loginFieldHeight).isActive = true
        view.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    private func setupViewDivider(viewDivider: UIView) {
        viewDivider.centerYAnchor.constraint(equalTo: centerYAnchor, constant: UIScreen.main.bounds.height * 0.09).isActive = true
        viewDivider.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        viewDivider.widthAnchor.constraint(equalTo: widthAnchor, multiplier: Constants.Login.dividerWidth).isActive = true
        viewDivider.heightAnchor.constraint(equalTo: loginButton.heightAnchor, multiplier:  Constants.Login.dividerHeight).isActive = true
    }
}

