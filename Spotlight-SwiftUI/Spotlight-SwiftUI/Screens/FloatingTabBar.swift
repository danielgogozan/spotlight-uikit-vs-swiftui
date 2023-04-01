//
//  FloatinTabBar.swift
//  Spotlight-SwiftUI
//
//  Created by Daniel Gogozan on 14.03.2023.
//

import SwiftUI
import Combine

enum TabItem: String, CaseIterable {
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
}

class TabSettings: ObservableObject {
    @Published var show = true
}

struct FloatingTabBar: View {
    @State private var selectedTab = TabItem.home
    let apiService = NewsService(apiService: .preview)
    @StateObject var tabSettings = TabSettings()
    @State private var offset: CGSize = .zero
    private var cancellables = [AnyCancellable]()
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
            TabView(selection: $selectedTab) {
                HomeView(apiService: apiService)
                    .ignoresSafeArea(.all, edges: .bottom)
                    .tag(TabItem.home)
                FavoriteView()
                    .ignoresSafeArea(.all, edges: .bottom)
                    .tag(TabItem.favorite)
            }
            .environmentObject(tabSettings)
            
                VStack(spacing: 0) {
                    HStack(spacing: 70) {
                        ForEach(TabItem.allCases, id: \.self) { tab in
                            Button {
                                selectedTab = tab
                            } label: {
                                VStack {
                                    Image(uiImage: tab.image)
                                        .resizable()
                                        .renderingMode(.template)
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 22, height: 22)
                                        .foregroundColor(selectedTab != tab ?
                                                         Asset.Colors.gray.color.swiftUI : Asset.Colors.primary.color.swiftUI)
                                    Text(tab.title)
                                        .foregroundColor(selectedTab != tab ?
                                                         Asset.Colors.gray.color.swiftUI :
                                                            Asset.Colors.black.color.swiftUI)
                                        .font(FontFamily.Nunito.regular.font(size: 10).swiftUI)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 30)
                    .padding(.vertical, 7)
                    .background(Color.white) // important to spend across all space
                    .cornerRadius(200)
                    .padding(.bottom, (UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0) - 30)
                    .offset(offset)
                    .shadow(color: .black.opacity(0.3), radius: 0.75)
            }
                .onChange(of: tabSettings.show) { show in
                    if !show {
                        withAnimation {
                            self.offset = .init(width: 0, height: 100)
                        }
                    } else {
                        withAnimation(.linear(duration: 0.1)) {
                            self.offset = .zero
                        }
                    }
                }
        }
    }
}

struct FloatinTabBar_Previews: PreviewProvider {
    static var previews: some View {
        FloatingTabBar()
    }
}
