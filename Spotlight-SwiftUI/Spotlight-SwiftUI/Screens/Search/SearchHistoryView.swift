//
//  SearchHistoryView.swift
//  Spotlight-SwiftUI
//
//  Created by Daniel Gogozan on 30.03.2023.
//

import SwiftUI

struct SearchHistoryView: View {
    @EnvironmentObject var tabSettings: TabSettings
    @State private var selection: Int?
    @ObservedObject var viewModel: SearchHistoryViewModel
    
    var body: some View {
        ZStack {
            NavigationLink(destination: SearchResultsView(viewModel: SearchResultsViewModel()),
                           tag: 1,
                           selection: $selection) { }
            
            GeometryReader { geometry in
                VStack {
                    StatefulView(contentView: contentView, viewModel: viewModel)
                }
                .padding()
                .toolbar {
                    HStack {
                        SearchBarView(image: Asset.Images.rightArrow.image)
                            .frame(width: 300)
                            .onTapGesture {
                                selection = 1
                            }
                            .padding([.leading], -(geometry.size.width - 320) / 2)
                    }
                    .frame(width: geometry.size.width)
                }
            }
        }
        .onAppear {
            tabSettings.show = false
        }
    }
    
    var contentView: some View {
        VStack {
            Text("Hello, history!")
        }
    }
}

struct SearchHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        SearchHistoryView(viewModel: SearchHistoryViewModel())
    }
}
