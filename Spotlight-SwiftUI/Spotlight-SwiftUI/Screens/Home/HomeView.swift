//
//  HomeView.swift
//  Spotlight-SwiftUI
//
//  Created by Daniel Gogozan on 14.03.2023.
//

import SwiftUI

struct HomeView: View {
    var articleViewModel: ArticleViewModel
    @State var selection: Int?
    @EnvironmentObject var tabSettings: TabSettings
    
    var body: some View {
        NavigationView {
            ZStack {
                NavigationLink(destination: SearchHistoryView(),
                               tag: 1,
                               selection: $selection) { }
                    
                GeometryReader { geometry in
                    VStack(alignment: .leading) {
                        ArticlesView(viewModel: articleViewModel,
                                     availableSize: geometry.size)
                        Spacer()
                    }
                    .padding([.top], 0.1) // IMPORTANT: - Force to respect top safe area
                    .toolbar {
                        searchToolbar
                        .frame(width: geometry.size.width)
                    }
                }
            }
            .ignoresSafeArea(.all, edges: .bottom)
            .onAppear {
                tabSettings.show = true
            }
        }
        .accentColor(Asset.Colors.black.color.swiftUI) // mandatory on NavigationView
    }
    
    var searchToolbar: some View {
        HStack {
            Spacer()
            SearchBarView(searchKey: .constant(""))
                .frame(width: 330)
                .onTapGesture {
                    selection = 1
                }
            Spacer()
            Button { } label: {
                Image(uiImage: Asset.Images.iconNotification.image)
                    .renderingMode(.template)
                    .foregroundColor(Asset.Colors.primary.color.swiftUI)
            }
            Spacer()
        }
    }
}
    
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(articleViewModel: .preview)
    }
}
