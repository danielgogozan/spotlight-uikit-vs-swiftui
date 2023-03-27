//
//  LoginBottomView.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 10.05.2022.
//

import Foundation
import UIKit

class LoginBottomView: UIView {
    // MARK: - Private properties
    @IBOutlet private weak var contentStackView: UIStackView!
    @IBOutlet private weak var socialMediaStackView: UIStackView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
}

private extension LoginBottomView {
    func commonInit() {
        loadNib(from: LoginBottomView.self)
        addSocialMediaViews()
    }
    
    func addSocialMediaViews() {
        SocialMedia.allCases.forEach { socialMedia in
            let socialMediaView = SocialMediaView()
            socialMediaView.image = socialMedia.icon
            socialMediaView.socialMediaName = L10n.loginWith(socialMedia.name)
            socialMediaStackView.addArrangedSubview(socialMediaView)
        }
    }
}
