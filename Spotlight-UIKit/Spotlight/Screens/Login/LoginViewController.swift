//
//  LoginViewController.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 09.05.2022.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - Private properties
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var contentStackView: UIStackView!
    @IBOutlet private weak var headerView: LoginHeaderView!
    @IBOutlet private weak var bottomView: LoginBottomView!
    @IBOutlet private weak var emailView: STextFieldView!
    @IBOutlet private weak var passwordView: STextFieldView!
    @IBOutlet private weak var buttonsStackView: UIStackView!
    @IBOutlet private weak var loginButton: SButton!
    @IBOutlet private weak var registerButton: SButton!
    @IBOutlet private weak var rememberCheckbox: CheckboxButton!
    @IBOutlet private weak var rememberLabel: UILabel!
    @IBOutlet private weak var forgetPasswordButton: UIButton!
    
    var login: (() -> Void)?
    var loginButtonCoordinates: (x: CGFloat, y: CGFloat)?
    var viewModel: LoginViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        withTransparentNavBar()
        setupViews()
        bindViewModel()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        viewModel.login()
    }
}

// MARK: - Private API
private extension LoginViewController {
    func setupViews() {
        rememberLabel.font = FontFamily.Nunito.light.font(size: 13)
        forgetPasswordButton.setTitle(L10n.loginForgetPassword, for: .normal)
        forgetPasswordButton.titleLabel?.font = FontFamily.Nunito.light.font(size: 12)
        forgetPasswordButton.setTitleColor(Asset.Colors.secondary.color, for: .normal)
        
        rememberCheckbox.addTarget(self, action: #selector(rememberCheckboxValueChanged(_:)), for: .valueChanged)
        
        loginButton.setTitle(L10n.loginButton, for: .normal)
        loginButton.titleLabel?.font = FontFamily.Nunito.regular.font(size: 14)
        _ = loginButton.applyGradient(colours: [Asset.Colors.primary.color, Asset.Colors.redish.color])
        
        registerButton.setTitle(L10n.loginRegisterButton, for: .normal)
        registerButton.titleLabel?.font = FontFamily.Nunito.regular.font(size: 14)
        setupTextFields()
    }
    
    func setupTextFields() {
        let textFieldStyle = ViewStyle(backgroundColor: .white,
                                       shadowRadius: 2,
                                       shadowColor: Asset.Colors.black.color,
                                       shadowOffset: CGSize(width: 0, height: 1),
                                       shadowOpacity: 0.3,
                                       round: true)
        emailView.customize(style: textFieldStyle,
                            placeholder: L10n.loginEmail,
                            image: Asset.Images.email.image,
                            font: FontFamily.Nunito.regular.font(size: 14),
                            errorFont: FontFamily.Nunito.light.font(size: 10))
        passwordView.customize(style: textFieldStyle,
                               placeholder: L10n.loginPassword,
                               image: Asset.Images.lock.image,
                               font: FontFamily.Nunito.regular.font(size: 14),
                               errorFont: FontFamily.Nunito.light.font(size: 10))
        passwordView.hideText = true
        
        emailView.textValue.bind { [weak self] text in
            self?.viewModel.email.value = text
        }
        
        passwordView.textValue.bind { [weak self] text in
            self?.viewModel.password.value = text
        }
    }
    
    func bindViewModel() {
        viewModel.areCredentialsValid.bind { [weak self] areCredentialsValid in
            self?.loginButton.isEnabled = areCredentialsValid
        }
        
        viewModel.emailPublisher.bind { [weak self] errorMessage in
            guard let self = self,
                  let errorMessage = errorMessage else { return }
            
            guard !errorMessage.isEmpty else {
                self.emailView.clearError()
                return
            }
            
            self.emailView.displayError(with: errorMessage)
        }
        
        viewModel.passwordPublisher.bind { [weak self] errorMessage in
            guard let self = self,
                  let errorMessage = errorMessage else { return }
            
            guard !errorMessage.isEmpty else {
                self.passwordView.clearError()
                return
            }
            
            self.passwordView.displayError(with: errorMessage)
        }
        
        viewModel.loginResultPublisher.bind { [weak self] (token, error) in
            guard let self else { return }
            if let error {
                self.view.showToast(with: error.localizedDescription, color: Asset.Colors.redish.color)
                return
            }
            
            if token != nil {
                self.login?()
            }
        }
    }
    
    @objc func rememberCheckboxValueChanged(_ sender: CheckboxButton) {
        print(sender.isChecked)
    }
}
