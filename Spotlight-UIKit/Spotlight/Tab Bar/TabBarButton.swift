//
//  TabBarButton.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 17.02.2022.
//

import UIKit

enum TabBarButton: Int, CaseIterable {
    case home
    case favorite
    
    var title: String {
        switch self {
        case .home:
            return L10n.tabHome
        case .favorite:
            return L10n.tabFavorite
        }
    }
    var image: UIImage {
        switch self {
        case .home:
            return Asset.Images.tabHome.image
        case .favorite:
            return Asset.Images.tabFavorite.image
        }
    }
    
    var selectedImage: UIImage {
        self.image.withColor(Asset.Colors.primary.color)
    }
}
