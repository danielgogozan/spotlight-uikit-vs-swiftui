//
//  TopHeadlinesCell.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 22.02.2022.
//

import Foundation
import UIKit

class HeadlinesCell: UICollectionViewCell {
    
    static let reuseIdentifier = String(describing: HeadlinesCell.self)
    
    @IBOutlet weak var topArticleView: TopArticleView!
    
    private var articleViewModel: ArticleViewModel?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.cornerRadius = 10
    }

    func setup(articleViewModel: ArticleViewModel, emphasized: Bool = false) {
        self.articleViewModel = articleViewModel
        bindViewModel(emphasized)
    }
    
    func toDefault() {
        topArticleView.toDefault()
    }
    
    func toCustom() {
        topArticleView.toCustom()
    }
    
    private func bindViewModel(_ emphasized: Bool = false) {
        articleViewModel?.articleSubject.bind {[weak self] article in
            guard let article = article else { return }
            self?.topArticleView.setup(topHeadline: article, emphasize: emphasized)
        }
    }
}
