//
//  SearchHistoryView.swift
//  Spotlight-SwiftUI
//
//  Created by Daniel Gogozan on 30.03.2023.
//

import SwiftUI

struct SearchHistoryView: View {
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.date, order: SortOrder.reverse)
    ])
    var history: FetchedResults<Search>
    
    @Environment(\.managedObjectContext) private var managedObjectContext
    @EnvironmentObject var tabSettings: TabSettings
    @ObservedObject var viewModel: SearchHistoryViewModel
    
    @State private var selection: Int?
    @State private var query: String = ""
    
    var body: some View {
        ZStack {
            NavigationLink(destination: SearchResultsView(viewModel: SearchResultsViewModel(apiService: .preview, filterData: FilterData(query: query, selectedCategory: .filter))),
                           tag: 1,
                           selection: $selection) { }
            
            GeometryReader { geometry in
                Color.clear
                    .toolbar {
                        HStack {
                            SearchBarView(searchKey: $query, image: Asset.Images.rightArrow.image) {
                                saveQuery()
                                selection = 1
                            }
                            .frame(width: 300)
                            .padding([.leading], -(geometry.size.width - 320) / 2.75)
                        }
                        .frame(width: geometry.size.width)
                    }
            }
            
            List(history.compactMap { $0.key }.filter { !$0.isEmpty }, id: \.self) { key in
                HStack {
                    Image(uiImage: Asset.Images.history.image)
                        .resizable()
                        .tint(Asset.Colors.black.color.swiftUI)
                        .frame(maxWidth: 15, maxHeight: 15)
                    Text("\(key)")
                        .font(FontFamily.Nunito.regular.font(size: 15).swiftUI)
                        .foregroundColor(Asset.Colors.black.color.swiftUI)
                    Spacer()
                    Image(uiImage: Asset.Images.close.image)
                        .resizable()
                        .tint(Asset.Colors.black.color.swiftUI)
                        .frame(maxWidth: 15, maxHeight: 15)
                        .onTapGesture {
                            removeQuery(by: key)
                        }
                }
                .onTapGesture {
                    query = key
                    selection = 1
                }
            }
            .listStyle(.plain)
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
    
    func saveQuery() {
        guard !query.isEmpty else { return }
        
        let search = Search(context: managedObjectContext)
        search.date = .now
        search.key = query
        do {
            try managedObjectContext.save()
        } catch {
            print("[CORE DATA] \(error.localizedDescription)")
        }
    }
    
    func removeQuery(by key: String) {
        guard let search = history.first(where: { $0.key == key }) else { return }
        managedObjectContext.delete(search)
    }
}

struct SearchHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        SearchHistoryView(viewModel: SearchHistoryViewModel())
    }
}
