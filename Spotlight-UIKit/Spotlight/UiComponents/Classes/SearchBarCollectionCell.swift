//
//  SearchBarCollectionCell.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 21.04.2022.
//

import Foundation
import UIKit

class SearchBarCollectionCell: UICollectionViewCell {
    
    // MARK: - Private properties
    @IBOutlet private weak var searchBarView: SearchBarView!
    
    // MARK: - Public properties
    var focus: Bool = false {
        didSet {
            if focus {
                searchBarView.focus()
            }
        }
    }

    let liveTextSubject = Observable<String>("")
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        searchBarView.liveText.bind { [weak self] text in
            self?.liveTextSubject.value = text
        }
    }
}
