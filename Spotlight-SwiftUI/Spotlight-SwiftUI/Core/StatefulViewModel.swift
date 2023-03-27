//
//  StatefulViewModel.swift
//  Boovie
//
//  Created by Daniel Gogozan on 10.02.2023.
//  Copyright © 2023 Softvision. All rights reserved.
//

import Foundation

enum ViewState<P, E: Error>{
    case idle
    case loading
    case content(_ payload: P)
    case noContent
    case error(_ error: E)
    
    var payload: P? {
        switch self {
        case .content(let payload):
            return payload
        default:
            return nil
        }
    }
}

extension ViewState where P: Equatable {
    static func == (lhs: ViewState, rhs: ViewState) -> Bool {
        switch(lhs, rhs) {
        case (.idle, .idle):
            return true
        case (.loading, .loading):
            return true
        case(.content(let content1), .content(let content2)):
            return content1 == content2
        case (.error(let err1), .error(let err2)):
            return err1.localizedDescription == err2.localizedDescription
        default:
            return false
        }
    }
}

class StatefulViewModel<P, E: Error>: ObservableObject {
    @Published var state: ViewState<P, E> = .idle
}
