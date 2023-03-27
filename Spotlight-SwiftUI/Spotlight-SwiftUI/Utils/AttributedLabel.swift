//
//  AttributedLabel.swift
//  Spotlight-SwiftUI
//
//  Created by Daniel Gogozan on 11.03.2023.
//

import SwiftUI

struct AttributedLabel: UIViewRepresentable {
    let text: String
    let link: String
    
    private var attributedString: NSMutableAttributedString {
        let message = text
        let bodyAttr: [NSAttributedString.Key: Any] = [.font: FontFamily.Nunito.light.font(size: 14),
                                                       .foregroundColor: Asset.Colors.black.color]
        
        let linkAttr: [NSAttributedString.Key: Any] = [.font: FontFamily.Nunito.light.font(size: 14),
                                                       .foregroundColor: Asset.Colors.secondary.color]
        
        return StringUtils.shared.mutableAttributedString(message: message, links: [link], bodyAttr: bodyAttr, linkAttr: [linkAttr])
    }
    
    func makeUIView(context: Context) -> UITextView {
        let label = UITextView()
        label.text = text
        label.attributedText = attributedString
        return label
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) { }
}
