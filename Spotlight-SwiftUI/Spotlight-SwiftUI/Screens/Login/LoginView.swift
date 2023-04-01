//
//  LoginView.swift
//  Spotlight-SwiftUI
//
//  Created by Daniel Gogozan on 11.03.2023.
//

import SwiftUI

struct LoginView: View {
    @State private var rememberPassword: Bool = false
    @ObservedObject var viewModel: LoginViewModel
    
    var termsString: AttributedString {
        var result = AttributedString(L10n.loginInfoLink)
        result.foregroundColor = Asset.Colors.secondary.color
        return result
    }
    
    var body: some View {
        VStack {
            StatefulView(contentView: contentView, viewModel: viewModel)
        }
    }
    
    var contentView: some View {
        ScrollView {
            VStack(spacing: 20) {
                header
                STextField(error: $viewModel.emailError,
                           image: Asset.Images.email.image,
                           placeholder: L10n.loginEmail,
                           imageHeight: 20) { newEmail in
                    viewModel.email = newEmail
                }
                STextField(error: $viewModel.passwordError,
                           image: Asset.Images.lock.image,
                           placeholder: L10n.loginPassword,
                           isSecured: true,
                           imageHeight: 20) { newPassword in
                    viewModel.password = newPassword
                }
                HStack {
                    HStack {
                        Toggle(isOn: $rememberPassword) {
                            Text(L10n.loginRememberPassword)
                                .font(FontFamily.Nunito.light.font(size: 13).swiftUI)
                                .foregroundColor(Asset.Colors.black.color.swiftUI)
                        }
                        .toggleStyle(CheckboxToggleStyle())
                        
                    }
                    Spacer()
                    Button(L10n.loginForgetPassword) { }
                        .font(FontFamily.Nunito.light.font(size: 12).swiftUI)
                }
                
                HStack {
                    Button(L10n.loginButton) {
                        viewModel.login()
                    }
                    .disabled(!viewModel.isLoginActive)
                    .padding(7)
                    .frame(maxWidth: .infinity)
                    .background(!viewModel.isLoginActive ? Gradients.inactiveGradient : Gradients.activeGradient)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
                    .font(FontFamily.Nunito.regular.font(size: 14).swiftUI)
                    
                    Button(L10n.loginRegisterButton) { }
                        .padding(7)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(Asset.Colors.redish.color.swiftUI)
                        .border(Asset.Colors.redish.color.swiftUI, width: 1, cornerRadius: 25)
                        .font(FontFamily.Nunito.regular.font(size: 14).swiftUI)
                }
                socialMedia
                Spacer()
            }
            .padding(40)
        }
    }
    
    var header: some View {
        VStack {
            Image(uiImage: Asset.Images.newsPeople.image)
                .resizable()
                .frame(width: 200, height: 128)
            HStack(spacing: 15) {
                VStack(alignment: .leading, spacing: 5) {
                    Text(L10n.loginButton)
                        .font(FontFamily.Nunito.semiBold.font(size: 24).swiftUI)
                        .foregroundColor(Asset.Colors.primary.color.swiftUI)
                    Text(AttributedString(L10n.loginInfo) + termsString)
                        .font(FontFamily.Nunito.light.font(size: 14).swiftUI)
                        .foregroundColor(Asset.Colors.black.color.swiftUI)
                }
                Image(uiImage: Asset.Images.logo1.image)
                    .resizable()
                    .frame(width: 155, height: 140)
            }
        }
    }
    
    var socialMedia: some View {
        VStack(alignment: .leading, spacing: 20) {
            ForEach(SocialMedia.allCases, id: \.name) { socialMedia in
                HStack(spacing: 15) {
                    Image(uiImage: socialMedia.icon)
                        .resizable()
                        .frame(width: 20, height: 20)
                    Text(L10n.loginWith(socialMedia.name))
                        .font(FontFamily.Nunito.light.font(size: 15).swiftUI)
                }
                .frame(width: 190)
                .padding([.top, .bottom], 5)
                .border(Asset.Colors.lightGray.color.swiftUI.opacity(0.5),
                        width: 2,
                        cornerRadius: 25)
                .fixedSize(horizontal: true, vertical: true)
            }
        }
        .foregroundColor(Asset.Colors.black.color.swiftUI)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewModel: LoginViewModel(apiService: .preview,
                                            keychainManager: KeychainManager(keychain: Keychain())))
    }
}
