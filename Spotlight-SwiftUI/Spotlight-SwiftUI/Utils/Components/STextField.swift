//
//  STextField.swift
//  Spotlight-SwiftUI
//
//  Created by Daniel Gogozan on 11.03.2023.
//

import SwiftUI

struct STextField: View {
    @State var isActive = false
    @State var text: String = ""
    @Binding var error: String
    
    var image: UIImage = UIImage()
    var placeholder: String = ""
    var isSecured: Bool = false
    var imageColor: UIColor?
    var height: CGFloat = 20
    var imageHeight: CGFloat = 15
    var didEndEditing: ((String) -> Void)?
    var onImageTap: (() -> Void)?
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                HStack {
                    if isSecured {
                        SecureField(placeholder, text: $text) {
                            didEndEditing?(text)
                        }
                    } else {
                        TextField(placeholder, text: $text) { isFocused in
                            guard !isFocused else { return }
                            didEndEditing?(text)
                            isActive = true
                        }
                        .frame(height: height)
                    }
                }
                .overlay(content: {
                    GeometryReader { geometry in
                        VStack(alignment: .trailing) {
                            Spacer()
                            Image(uiImage: image)
                                .resizable()
                                .offset(x: geometry.size.width - imageHeight, y: -geometry.size.height/2 - imageYOffset)
                                .frame(width: imageHeight, height: imageHeight)
                                .foregroundColor(imageColor == nil ? Asset.Colors.redish.color.swiftUI : imageColor!.swiftUI)
                                .onTapGesture {
                                    onImageTap?()
                                }
                        }
                    }
                })
                .modifier(CapsuleTextfieldModifier())
                
                if !error.isEmpty && isActive {
                    Text(error)
                        .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.35)))
                        .font(FontFamily.Nunito.light.font(size: 10).swiftUI)
                        .foregroundColor(Asset.Colors.secondary.color.swiftUI)
                }
            }
        }
    }
    
    // Login assets have a wrong dimension so I have to fix it here
    var imageYOffset: CGFloat {
        imageHeight == height ? 0 : imageHeight / 2
    }
}

struct OvalTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(10)
            .background(.white)
            .cornerRadius(20)
            .shadow(color: .black.opacity(0.3), radius: 3, y: 1.2)
    }
}

struct CapsuleTextfieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(12)
            .background(Color.white)
            .cornerRadius(30)
            .font(FontFamily.Nunito.regular.font(size: 14).swiftUI)
            .shadow(color: .black.opacity(0.3), radius: 3, y: 1.2)
    }
}
