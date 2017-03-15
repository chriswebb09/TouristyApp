import UIKit
import SnapKit

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
        questionLabel.text = questions.queryOne.questionText
        firstChoiceButton.setTitle("Hell yeah", for: .normal)
        secondChoiceButton.setTitle("Shnope", for: .normal)
        
        queryViews.forEach { view in
            addSubviewsToView(subview: view)
        }
        
        questionLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self).offset(UIScreen.main.bounds.height * -0.2)
        }
        firstChoiceButton.snp.makeConstraints { make in
            make.width.equalTo(self).multipliedBy(Constants.Login.loginFieldWidth)
            make.height.equalTo(self).multipliedBy(Constants.Login.loginFieldHeight)
            make.centerX.equalTo(self)
            make.centerY.equalTo(self)
        }
        secondChoiceButton.snp.makeConstraints { make in
            make.width.equalTo(self).multipliedBy(Constants.Login.loginFieldWidth)
            make.height.equalTo(self).multipliedBy(Constants.Login.loginFieldHeight)
            make.centerX.equalTo(self)
            make.top.equalTo(firstChoiceButton.snp.bottom).offset(UIScreen.main.bounds.height * 0.05)
        }
    }
}
