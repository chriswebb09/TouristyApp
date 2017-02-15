import UIKit

class QueryView: UIView {
    
    var questions = Queries()
    
    var questionLabel: UILabel = {
        var questionLabel = UILabel()
        return questionLabel
    }()
    
    var firstChoiceButton: UIButton = {
        var firstButton = UIButton()
        firstButton.backgroundColor = UIColor.babyBlueColor()
        return firstButton
    }()
    
    var secondChoiceButton: UIButton = {
        var secondChoiceButton = UIButton()
        secondChoiceButton.backgroundColor = .lightGray
        return secondChoiceButton
    }()
    
    var thirdChoiceButton: UIButton = {
        var thirdChoiceButton = UIButton()
        return thirdChoiceButton
    }()
    
    var responseLabel: UILabel = {
        var response = UILabel()
        return response
    }()
    
    var queryViews = [UIView]()

    override func layoutSubviews() {
        super.layoutSubviews()
        frame = UIScreen.main.bounds
        backgroundColor = .white
        self.queryViews = [questionLabel, firstChoiceButton, secondChoiceButton, thirdChoiceButton]
        setupConstraints()
    }
    
    func addSubviewsToView(subview: UIView) {
        addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupConstraints() {
        queryViews.forEach { view in
            addSubviewsToView(subview: view)
        }
        
        questionLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
        questionLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: UIScreen.main.bounds.height * -0.2).isActive = true
        questionLabel.text = questions.queryOne.questionText
        
        firstChoiceButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: Constants.Login.loginFieldWidth).isActive = true
        firstChoiceButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: Constants.Login.loginFieldHeight).isActive = true
        firstChoiceButton.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
        firstChoiceButton.centerYAnchor.constraint(equalTo: centerYAnchor, constant: UIScreen.main.bounds.height * 0.0).isActive = true
        firstChoiceButton.setTitle("Hell yeah", for: .normal)
        
        secondChoiceButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: Constants.Login.loginFieldWidth).isActive = true
        secondChoiceButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: Constants.Login.loginFieldHeight).isActive = true
        secondChoiceButton.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
        secondChoiceButton.topAnchor.constraint(equalTo: firstChoiceButton.bottomAnchor, constant: UIScreen.main.bounds.height * 0.05).isActive = true
        //firstChoiceButton.centerYAnchor.constraint(equalTo: centerYAnchor, constant: UIScreen.main.bounds.height * 0.0).isActive = true
        secondChoiceButton.setTitle("Shnope", for: .normal)
    }
    
    
    func tapFirstAnswer() {
        
    }
}
