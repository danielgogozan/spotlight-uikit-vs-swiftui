//
//  Observable.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 17.02.2023.
//

import Foundation

final class Observable<T> {
    typealias Listener = (T) -> Void
    var listener: Listener?
    
    var value: T {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.listener?(self.value)
            }
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(_ listener: Listener?) {
        self.listener = listener
        
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.listener?(self.value)
        }
    }
}
