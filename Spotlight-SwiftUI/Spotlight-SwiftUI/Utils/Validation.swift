//
//  Validation.swift
//  Spotlight-SwiftUI
//
//  Created by Daniel Gogozan on 13.03.2023.
//

import Foundation

struct Validation {
    static func validateEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
