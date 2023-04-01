//
//  PillFilterView.swift
//  Boovie
//
//  Created by Daniel Gogozan on 06.02.2023.
//  Copyright © 2023 Softvision. All rights reserved.
//

import SwiftUI

struct PillFilterView: View {
    @Binding var selected: [String]
    let filterItems: [String]
    let multipleSelection: Bool
    var openExtraViewIfNeeded: (() -> Void)?
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 10) {
                    ForEach(filterItems, id: \.self) { item in
                        Button {
                            if  multipleSelection,
                                selected.contains(item),
                                let index = selected.firstIndex(where: { $0 == item }) {
                                selected.remove(at: index)
                            } else {
                                if multipleSelection {
                                    selected.append(item)
                                } else {
                                    selected = [item]
                                    openExtraViewIfNeeded?()
                                }
                                
                                withAnimation {
                                    guard let index = filterItems.firstIndex(where: { $0 == item }) else {
                                        return
                                    }
                                    proxy.scrollTo(filterItems[index], anchor: .center)
                                }
                            }
                        } label: {
                            HStack {
                                if item.capitalized == "Filter" {
                                    Image(uiImage: Asset.Images.filter.image)
                                        .renderingMode(.template)
                                        .foregroundColor(selected.contains(item) ? .white : Asset.Colors.black.color.swiftUI)
                                }
                                Text(item.capitalized)
                            }
                        }
                        .padding([.top, .bottom], 7)
                        .padding([.leading, .trailing], 14)
                        .font(FontFamily.Nunito.regular.font(size: 13).swiftUI)
                        .foregroundColor(selected.contains(item) ? .white : Asset.Colors.black.color.swiftUI)
                        .background(gradientBackground(item: item))
                        .clipShape(Capsule())
                        .border(Asset.Colors.searchBorder.color.swiftUI, width: 1, cornerRadius: 50)
                    }
                }
                .padding([.leading, .trailing], 7)
            }
            .padding(.top, 7)
        }
    }
    
    @ViewBuilder func gradientBackground(item: String) -> some View {
        if selected.contains(item) {
            LinearGradient(gradient: Gradient(colors: [Asset.Colors.primary.color.swiftUI.opacity(0.9),
                                                       Asset.Colors.primary.color.swiftUI.opacity(0.75)]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
        } else {
            Color(.white)
        }
    }
}

struct PillFilterView_Previews: PreviewProvider {
    static var previews: some View {
        PillFilterView(selected: .constant(["Pill 1"]), filterItems: ["Pill 1", "Pill 2"], multipleSelection: true)
    }
}
