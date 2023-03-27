//
//  StatefulView.swift
//  Boovie
//
//  Created by Daniel Gogozan on 10.02.2023.
//  Copyright © 2023 Softvision. All rights reserved.
//

import SwiftUI

protocol StatefulViewComponent: View {
    associatedtype Content: View
    associatedtype Payload: Any
    associatedtype Err: Error
    
    var contentView: Content { get }
    var noContentView: AnyView? { get }
    var viewModel: StatefulViewModel<Payload, Err> { get set }
}

struct StatefulView<Content: View, Payload: Any, Err: Error>: StatefulViewComponent {
    let contentView: Content
    let noContentView: AnyView?
    @ObservedObject var viewModel: StatefulViewModel<Payload, Err>
    
    init(contentView: Content, noContentView: AnyView? = nil, viewModel: StatefulViewModel<Payload, Err>) {
        self.contentView = contentView
        self.noContentView = noContentView
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            switch viewModel.state {
            case .loading:
                VStack(alignment: .center) {
                    Spacer()
                    ProgressView()
                        .tint(Asset.Colors.redish.color.swiftUI)
                        .progressViewStyle(.circular)
                    Spacer()
                }
            case .error(let error):
                Text("Error \(error.localizedDescription)")
            case .content:
                contentView
            case .noContent:
                if let noContentView {
                    noContentView
                } else {
                    Text("No data found")
                }
            default:
                EmptyView()
            }
        }
    }
}

//struct StatefulView_Previews: PreviewProvider {
//    static var previews: some View {
//        StatefulView(contentView: Text("Content view"), viewModel: PlaylistDetailsViewModel.preview)
//    }
//}
