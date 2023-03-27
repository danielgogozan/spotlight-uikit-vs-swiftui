//
//  LoginViewModel.swift
//  Spotlight-SwiftUI
//
//  Created by Daniel Gogozan on 13.03.2023.
//

import Foundation
import Combine

class LoginViewModel: StatefulViewModel<Credentials, Error> {
    private let apiService: AuthServiceProtocol
    private let keychainManager: KeychainManagerProtocol
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var emailError: String = ""
    @Published var passwordError: String = ""
    @Published var isLoginActive = false
    
    let loginResultPublisher = PassthroughSubject<String?, Never>()
    var cancellables = [AnyCancellable]()
    
    init(apiService: AuthServiceProtocol, keychainManager: KeychainManagerProtocol) {
        self.apiService = apiService
        self.keychainManager = keychainManager
        super.init()
        self.state = .content(Credentials(email: "", password: ""))
        subscribeToCredentials()
    }
    
    func subscribeToCredentials() {
        Publishers.CombineLatest(emailValidator, passwordValidator)
            .map { [weak self] email, pass -> (String, String)? in
                guard let email = email, let pass = pass else {
                    self?.isLoginActive = false
                    return nil
                }
                
                self?.isLoginActive = true
                return (email, pass)
            }
            .sink { [weak self] validatedCredentials in
                guard let validatedCredentials else { return }
                self?.state = .content(Credentials(email: validatedCredentials.0,
                                                   password: validatedCredentials.1))
            }
            .store(in: &cancellables)
    }
    
    func login() {
        // we're mocking login credentials because the API accepts only certain emails&password
        apiService.login(with: Constants.goodCredentials)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print(error)
                default:
                    break
                }
            }, receiveValue: { [weak self] token in
                self?.keychainManager.save(token, service: Constants.kTokenService, account: Constants.kTokenAccount)
                UserDefaults.standard.set(true, forKey: "didRunBefore")
            })
            .store(in: &cancellables)
    }
}

// MARK: - Private API
private extension LoginViewModel {
    var emailValidator: AnyPublisher<String?, Never> {
        return $email
            .map { [weak self] text -> String? in
                guard let self else { return nil }
                
                guard !text.isEmpty else {
                    self.emailError = "Please, enter your email"
                    return nil
                }
                
                guard Validation.validateEmail(text) else {
                    self.emailError = "Invalid email address"
                    return nil
                }
                
                self.emailError = ""
                return text
            }
            .eraseToAnyPublisher()
    }
    
    var passwordValidator: AnyPublisher<String?, Never> {
        return $password
            .map { [weak self] text in
                guard let self else { return nil }
                
                guard !text.isEmpty else {
                    self.passwordError = "Please, enter your password"
                    return nil
                }
                
                self.passwordError = ""
                return text
            }
            .eraseToAnyPublisher()
    }
}
