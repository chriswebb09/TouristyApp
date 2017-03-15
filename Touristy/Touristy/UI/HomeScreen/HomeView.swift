import UIKit
import SnapKit


class HomeView: UIView {
    
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
        backgroundColor = .white
        frame = UIScreen.main.bounds
        setupConstraints()
    }
}

extension HomeView {
    
    fileprivate func setupConstraints() {
        setupLogoImage(logoImageView: logoImageView)
        constraintSetup(views: [viewDivider, loginButton, signupButton])
        setupViewDivider(viewDivider: viewDivider)
        
        loginButton.snp.makeConstraints { make in
            make.bottom.equalTo(viewDivider.snp.top).offset(UIScreen.main.bounds.height * 0.18)
            make.width.equalTo(self).multipliedBy(Constants.Login.loginFieldWidth)
            make.height.equalTo(self).multipliedBy(0.085)
            make.centerX.equalTo(self)
        }
        
        signupButton.snp.makeConstraints { make in
            make.top.equalTo(viewDivider.snp.top).offset(UIScreen.main.bounds.height * 0.05)
            make.width.equalTo(self).multipliedBy(Constants.Login.loginFieldWidth)
            make.height.equalTo(self).multipliedBy(0.075)
            make.centerX.equalTo(self)
        }
        
        signupButton.isHidden = true
    }
    
    private func setupLogoImage(logoImageView: UIView) {
        addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        logoImageView.snp.makeConstraints { make in
            make.width.equalTo(self).multipliedBy(0.78)
            make.height.equalTo(self).multipliedBy(0.42)
            make.centerX.equalTo(self)
            make.centerY.equalTo(self).offset(bounds.height * -0.1)
        }
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
        
        view.snp.makeConstraints { make in
            make.width.equalTo(self).multipliedBy(Constants.Login.loginFieldWidth)
            make.height.equalTo(self).multipliedBy(Constants.Login.loginFieldHeight)
            make.centerX.equalTo(self)
        }
    }
    
    private func setupViewDivider(viewDivider: UIView) {
        viewDivider.snp.makeConstraints { make in
            make.centerY.equalTo(self).offset(UIScreen.main.bounds.height * 0.09)
            make.centerX.equalTo(self)
            make.width.equalTo(self).multipliedBy(Constants.Login.dividerWidth)
            make.height.equalTo(loginButton.snp.height).multipliedBy(Constants.Login.dividerHeight)
        }
    }
}

