//
//  HeadlinesTableViewCell.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 26.02.2022.
//

import Foundation
import UIKit

protocol HeadlinesNavigationDelegate: AnyObject {
    func onArticleDetails(articleViewModel: ArticleViewModel)
}

class HeadlinesTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var headlinesCollectionView: UICollectionView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    private var articleViewModels: [ArticleViewModel] = []
    var navigationDelegate: HeadlinesNavigationDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        headlinesCollectionView.dataSource = self
        headlinesCollectionView.delegate = self
        headlinesCollectionView.registerCell(ofType: HeadlinesCell.self)
        headlinesCollectionView.showsHorizontalScrollIndicator = false
        
        configureCollectionViewLayout()
        
        activityIndicator.color = Asset.Colors.primary.color
        activityIndicator.style = .medium
    }
    
    func setup(articleViewModels: [ArticleViewModel], isLoading: Bool) {
        self.articleViewModels = articleViewModels
        if isLoading {
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
        }
        headlinesCollectionView.reloadData()
    }
}

// MARK: - Private
private extension HeadlinesTableViewCell {
    private var collectionViewFlowLayout: UICollectionViewFlowLayout {
        // swiftlint:disable force_cast
        return headlinesCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
    }
    
    private func configureCollectionViewLayout() {
        collectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        collectionViewFlowLayout.itemSize = CGSize(width: headlinesCollectionView.frame.size.width - 80, height: headlinesCollectionView.frame.size.height - 20)
    }
    
    // Where scrollView should snap to
    private func indexOfMainCell() -> Int {
        let itemWidth = collectionViewFlowLayout.itemSize.width
        let proportionalOffset = headlinesCollectionView.contentOffset.x / itemWidth
        let index = Int(round(proportionalOffset))
        let safeIndex = max(0, min(articleViewModels.count - 1, index))
        return safeIndex
    }
}

// MARK: - Data Source
extension HeadlinesTableViewCell: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        articleViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cell(collectionView, for: indexPath)
        return cell
    }
    
    func cell(_ collectionView: UICollectionView, for indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueCell(ofType: HeadlinesCell.self, at: indexPath)
            cell.setup(articleViewModel: articleViewModels[indexPath.item])
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        navigationDelegate?.onArticleDetails(articleViewModel: articleViewModels[indexPath.item])
    }
}

// MARK: - Horizontal Paginated Collection View
extension HeadlinesTableViewCell: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionViewFlowLayout.itemSize
    }
}
