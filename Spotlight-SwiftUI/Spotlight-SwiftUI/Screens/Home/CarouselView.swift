//
//  CarouselView.swift
//  Spotlight-SwiftUI
//
//  Created by Daniel Gogozan on 01.04.2023.
//

import SwiftUI
struct CarouselView: View {
    var UIState: UIStateModel
    let articles: [Article]
    let availableSize: CGSize
    let onArticleTap: ((Article) -> Void)
    
    init(UIState: UIStateModel, articles: [Article], availableSize: CGSize, onArticleTap: @escaping (Article) -> Void) {
        self.articles = articles
        self.availableSize = availableSize
        self.onArticleTap = onArticleTap
        self.UIState = UIStateModel(activeCardId: !articles.isEmpty ? articles[0].id : "")
    }
    
    var body: some View {
        let spacing: CGFloat = 5
        let widthOfHiddenCards: CGFloat = 10
        let cardHeight: CGFloat = availableSize.height * 0.35
        
        return Canvas {
            Carousel(numberOfItems: CGFloat(articles.count),
                     spacing: spacing,
                     widthOfHiddenCards: widthOfHiddenCards,
                     articles: articles) {
                ForEach(articles, id: \.id ) { article in
                    CItem( _id: article.id,
                           spacing: spacing,
                           widthOfHiddenCards: widthOfHiddenCards,
                           cardHeight: cardHeight) {
                        HeadlineView(headline: article)
                            .onTapGesture {
                                onArticleTap(article)
                            }
                    }
                           .foregroundColor(.clear)
                           .cornerRadius(8)
                           .shadow(color: .clear, radius: 4, x: 0, y: 4)
                           .transition(AnyTransition.slide)
                           .animation(.spring())
                }
            }
                     .environmentObject( self.UIState )
        }
    }
}

struct Card: Decodable, Hashable, Identifiable {
    var id: Int
    var name: String = ""
}

class UIStateModel: ObservableObject {
    @Published var activeCard: Int = 0
    @Published var activeCardId: String = ""
    @Published var screenDrag: Float = 0.0
    
    init(activeCard: Int = 0, activeCardId: String, screenDrag: Float = 0.0) {
        self.activeCard = activeCard
        self.activeCardId = activeCardId
        self.screenDrag = screenDrag
    }
}

struct Carousel<Items: View>: View {
    let items: Items
    let numberOfItems: CGFloat
    let spacing: CGFloat
    let widthOfHiddenCards: CGFloat
    let totalSpacing: CGFloat
    let cardWidth: CGFloat
    let articles: [Article]
    
    @GestureState var isDetectingLongPress = false
    @EnvironmentObject var UIState: UIStateModel
    
    public init(
        numberOfItems: CGFloat,
        spacing: CGFloat,
        widthOfHiddenCards: CGFloat,
        articles: [Article],
        @ViewBuilder _ items: () -> Items) {
            self.items = items()
            self.numberOfItems = numberOfItems
            self.spacing = spacing
            self.widthOfHiddenCards = widthOfHiddenCards
            self.totalSpacing = (numberOfItems - 1) * spacing
            self.cardWidth = UIScreen.main.bounds.width - (widthOfHiddenCards*2) - (spacing*2)
            self.articles = articles
        }
    
    var body: some View {
        let totalCanvasWidth: CGFloat = (cardWidth * numberOfItems) + totalSpacing
        let xOffsetToShift = (totalCanvasWidth - UIScreen.main.bounds.width) / 2
        let leftPadding = widthOfHiddenCards + spacing
        let totalMovement = cardWidth + spacing
        
        let activeOffset = xOffsetToShift + (leftPadding) - (totalMovement * CGFloat(UIState.activeCard))
        let nextOffset = xOffsetToShift + (leftPadding) - (totalMovement * CGFloat(UIState.activeCard) + 1)
        
        var calcOffset = Float(activeOffset)
        
        if calcOffset != Float(nextOffset) {
            calcOffset = Float(activeOffset) + UIState.screenDrag
        }
        
        return HStack(alignment: .center, spacing: spacing) {
            items
        }
        .offset(x: CGFloat(calcOffset), y: 0)
        .gesture(DragGesture().updating($isDetectingLongPress) { currentState, gestureState, _ in
            self.UIState.screenDrag = Float(currentState.translation.width)
        }.onEnded { value in
            self.UIState.screenDrag = 0
            
            if (value.translation.width < -50) &&  self.UIState.activeCard < Int(numberOfItems) - 1 {
                UIState.activeCard += 1
                UIState.activeCardId = articles[UIState.activeCard].id
                let impactMed = UIImpactFeedbackGenerator(style: .medium)
                impactMed.impactOccurred()
            }
            
            if (value.translation.width > 50) && self.UIState.activeCard > 0 {
                self.UIState.activeCard -= 1
                UIState.activeCardId = articles[UIState.activeCard].id
                let impactMed = UIImpactFeedbackGenerator(style: .medium)
                impactMed.impactOccurred()
            }
        })
    }
}

struct Canvas<Content: View>: View {
    let content: Content
    @EnvironmentObject var UIState: UIStateModel
    
    @inlinable init(@ViewBuilder _ content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
            .background(Color.white.edgesIgnoringSafeArea(.all))
    }
}

struct CItem<Content: View>: View {
    @EnvironmentObject var UIState: UIStateModel
    let cardWidth: CGFloat
    let cardHeight: CGFloat
    
    var _id: String
    var content: Content
    
    @inlinable public init(
        _id: String,
        spacing: CGFloat,
        widthOfHiddenCards: CGFloat,
        cardHeight: CGFloat,
        @ViewBuilder _ content: () -> Content
    ) {
        self.content = content()
        self.cardWidth = UIScreen.main.bounds.width - (widthOfHiddenCards*2) - (spacing*2)
        self.cardHeight = cardHeight
        self._id = _id
    }
    
    var body: some View {
        content
            .frame(width: cardWidth, height: _id == UIState.activeCardId ? cardHeight : cardHeight - 10, alignment: .center)
            .overlay {
                _id == UIState.activeCardId ? Color.clear : Color.white.opacity(0.3)
            }
    }
}
