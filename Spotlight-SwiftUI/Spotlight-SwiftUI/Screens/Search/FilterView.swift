//
//  FilterView.swift
//  Spotlight-SwiftUI
//
//  Created by Daniel Gogozan on 01.04.2023.
//

import SwiftUI

struct FilterView: View {
    @State var sort: [String]
    @State var language: [String]
    var filterDidSave: ((Sorter?, Language?) -> Void)
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(spacing: 24) {
            title
                .padding([.top], 20)
            
            sortView
            languageView
            
            saveButton
            Spacer()
        }
        .padding()
    }
    
    var title: some View {
        HStack {
            Text(L10n.filter)
                .font(FontFamily.Nunito.bold.font(size: 22).swiftUI)
            Spacer()
            Button {
                sort = []
                language = []
            } label: {
                HStack {
                    Image(uiImage: Asset.Images.trash.image)
                    Text("Reset")
                        .font(FontFamily.Nunito.semiBold.font(size: 12).swiftUI)
                }
                .padding(8)
            }
            .border(Asset.Colors.black.color.swiftUI, width: 1, cornerRadius: 30)
        }
        .foregroundColor(Asset.Colors.black.color.swiftUI)
    }
    
    var sortView: some View {
        VStack(alignment: .leading) {
            Text(L10n.sort)
                .font(FontFamily.Nunito.semiBold.font(size: 16).swiftUI)
            PillFilterView(selected: $sort,
                           filterItems: Sorter.allCases.map { $0.rawValue },
                           multipleSelection: false)
        }
    }
    
    var languageView: some View {
        VStack(alignment: .leading) {
            Text(L10n.language)
                .font(FontFamily.Nunito.semiBold.font(size: 16).swiftUI)
            PillFilterView(selected: $language,
                           filterItems: Language.allCases.map { $0.rawValue },
                           multipleSelection: false)
        }
    }
    
    var saveButton: some View {
        Button(L10n.saveBtn) {
            let sorter = Sorter(rawValue: sort.first ?? "")
            let language = Language(rawValue: language.first ?? "")    
            filterDidSave(sorter, language)
            presentationMode.wrappedValue.dismiss()
        }
        .padding(5)
        .frame(maxWidth: .infinity)
        .font(FontFamily.Nunito.extraBold.font(size: 16).swiftUI)
        .foregroundColor(.white)
        .background(Gradients.activeGradient)
        .clipShape(Capsule())
    }
}

struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        FilterView(sort: [""], language: [""], filterDidSave: { _, _ in })
    }
}
