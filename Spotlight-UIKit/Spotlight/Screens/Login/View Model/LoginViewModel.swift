//
//  LoginViewModel.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 19.05.2022.
//

import Foundation

class LoginViewModel {
    
    // MARK: - Private properties
    private let apiService: AuthServiceProtocol
    private let keychainManager: KeychainManagerProtocol
    private var credentials = Credentials(email: "", password: "")
    
    // MARK: - Public properties
    var email = Observable<String?>(nil)
    var password = Observable<String?>(nil)
    var areCredentialsValid = Observable<Bool>(false)
    
    let emailPublisher = Observable<String?>(nil)
    let passwordPublisher = Observable<String?>(nil)
    let loginResultPublisher = Observable<(Token?, APIError?)>((nil, nil))
    
    init(apiService: AuthServiceProtocol, keychainManager: KeychainManagerProtocol) {
        self.apiService = apiService
        self.keychainManager = keychainManager
        
        listenToCredentials()
    }
    
    // MARK: - Public API
    func login() {
        // we're mocking login credentials because the API accepts only certain emails&password
        return apiService.login(with: Constants.goodCredentials) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let token):
                print("Received token: \(token)")
                self.keychainManager.save(token, service: Constants.kTokenService, account: Constants.kTokenAccount)
                self.loginResultPublisher.value = (token, nil)
            case .failure(let error):
                print(error)
                self.loginResultPublisher.value = (nil, error)
            }
        }
    }
    
    func listenToCredentials() {
        email.bind { [weak self] text in
            defer { self?.updateCredentials() }
            guard let self = self else { return }
            guard let text = text else { self.emailPublisher.value = nil; return }

            guard !text.isEmpty else {
                self.emailPublisher.value = "Please, enter your email"
                return
            }
            
            guard self.isValidEmail(text) else {
                self.emailPublisher.value = "Invalid email address"
                return
            }
            
            self.emailPublisher.value = ""
        }
        
        password.bind { [weak self] text in
            defer { self?.updateCredentials() }
            guard let self = self else { return }
            guard let text = text else { self.passwordPublisher.value = nil; return }

            guard !text.isEmpty else {
                self.passwordPublisher.value = "Please, enter your password"
                return
            }
            
            self.passwordPublisher.value = ""
        }
    }
    
    func updateCredentials() {
        guard let email = email.value, let pass = password.value else {
            areCredentialsValid.value = false
            return
        }
        
        areCredentialsValid.value = isValidEmail(email) && !(pass.isEmpty)
        
        if areCredentialsValid.value {
            credentials = Credentials(email: email, password: pass)
        }
    }
}

// MARK: - Private API
private extension LoginViewModel {
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        
        return emailPred.evaluate(with: email)
    }
}
