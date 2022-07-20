//
//  ContentView.swift
//  learningApp
//
//  Created by Bijen Shrestha on 26/04/2022.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var game: EmojiMemoryGame
    
    @Namespace private var dealingNamespace
    
    var body: some View {
//            ScrollView{
//                LazyVGrid(columns: [GridItem(.adaptive(minimum: 70))]) {
        //            ForEach(emojis, id: \.self) { emoji in
        //                CardView(content: emoji)
        //            }
//                }
//          }
                    

        ZStack(alignment: .bottom) {
            VStack {
                gameBody
                HStack {
                    shuffle
                    Spacer()
                    restart
                }
                .padding(.horizontal)
               
            }
            deckBody
        }
        .padding()
        .foregroundColor(.blue)

            
//            Spacer()
//
//            HStack {
//                removeButton
//                Spacer()
//                addButton
//            }
//            .font(.largeTitle)
//            .padding(.horizontal)
            
        
    }
    
    @State private var dealt = Set<Int>()
    
    private func deal(_ card: EmojiMemoryGame.Card) {
        dealt.insert(card.id)
    }
    
    private func isUndealt(_ card: EmojiMemoryGame.Card) -> Bool {
        !dealt.contains(card.id)
    }
    
    private func dealAnimation(for card: EmojiMemoryGame.Card) -> Animation {
        var delay = 0.0
        if let index = game.cards.firstIndex(where: { $0.id == card.id}) {
            delay = Double(index) * (DrawingConstants.totalDealDuration / Double(game.cards.count))
        }
        return Animation.easeInOut(duration: DrawingConstants.dealDuration).delay(delay)
    }
    
    
    var gameBody: some View {
        AspectVGrid(items: game.cards, aspectRatio: 2/3, content: {
            card in
            cardView(for: card)
        })
    }
    
    var deckBody: some View {
        ZStack{
            ForEach(game.cards.filter(isUndealt)) {
                card in CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(AnyTransition.asymmetric(insertion: .opacity, removal: .identity))
            }
        }
        .frame(width: DrawingConstants.unDealtwidth, height: DrawingConstants.unDealtHeight)
        .foregroundColor(.red)
        .onTapGesture {
            for card in game.cards {
                withAnimation(dealAnimation(for: card)) {
                    deal(card)
                }
            }
        }
    }
    
    var shuffle: some View{
        Button("Shuffle") {
            withAnimation{
                game.shuffle()
            }
        }
    }
    
    var restart: some View {
        Button("Restart") {
            withAnimation{
                dealt = []
                game.restart()
            }
        }
    }
    
    private func zindex(of card: EmojiMemoryGame.Card) -> Double {
        -Double(game.cards.firstIndex(where: { $0.id == card.id}) ?? 0)
    }
    
    @ViewBuilder
    private func cardView(for card: EmojiMemoryGame.Card) -> some View {
        if (isUndealt(card)) || (card.isMatch && !card.isFaceUp) {
//            Rectangle().opacity(0)
            Color.clear
        } else {
            CardView(card: card)
            .padding(4)
            .matchedGeometryEffect(id: card.id, in: dealingNamespace)
            .transition(AnyTransition.asymmetric(insertion: .identity, removal: .scale))
            .zIndex(zindex(of: card))
            .onTapGesture {
                withAnimation {
                    game.choose(card)
                    }
                }
        }
    }
    
    
    
//    var removeButton: some View {
//        Button(action: {
//            if(emojiCount > 1) {
//                emojiCount -= 1
//            }
//        }, label: {
//            VStack {
//                Image(systemName: "minus.circle")
//            }
//        })
//    }
//
//
//
//    var addButton: some View {
//        Button {
//            if(emojiCount < emojis.count) {
//                emojiCount += 1
//            }
//        } label: {
//            VStack {
//                Image(systemName: "plus.circle")
//            }
//        }
//    }
        
        
        
        
        
        
//        Text("Hello, world!")
//            .padding()
        
//        RoundedRectangle(cornerRadius: 25)
//            .stroke(lineWidth: 3)
//            .foregroundColor(.green)
//            .padding()

}


struct CardView: View {
    let card: MemoryGame<String>.Card
    
    @State private var animatedBonusRemaining: Double = 0
    
//    init(_ card: EmojiMemoryGame.Card) {
//        self.card = card
//    }
//
    var body: some View{
        GeometryReader { geometry in
            ZStack{
                Group {
                    if card.isConsumingBonusTime {
                        Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: (1-animatedBonusRemaining) * 360-90))
                            .onAppear {
                                animatedBonusRemaining = card.bonusTimeRemaining
                                withAnimation(.linear(duration: card.bonusTimeRemaining)) {
                                    animatedBonusRemaining = 0
                                }
                            }
                    } else {
                        Pie(startAngle: Angle(degrees: 15), endAngle: Angle(degrees: (1-card.bonusTimeRemaining) * 270))
                    }
                }
                    .padding(DrawingConstants.paddingValue).opacity(DrawingConstants.opacityValue)
                Text(card.content)
                    .rotationEffect(Angle.degrees(card.isMatch ? 360 : 0))
                    .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false))
                    .font(Font.system(size: DrawingConstants.fontSize))
                    .scaleEffect(scale(thatFits: geometry.size))

                
                //rotation doesn't occur
//                withAnimation(Animation.linear(duration: 1).repeatForever(autoreverses: false)){
//                    Text(card.content)
//                    .rotationEffect(Angle.degrees(card.isMatch ? 360 : 0))
//                    .font(Font.system(size: DrawingConstants.fontSize))
//                    .scaleEffect(scale(thatFits: geometry.size))
//                }

           }
            .cardify(isFaceUp: card.isFaceUp)
        }
    }
}


private struct DrawingConstants {
    static let cornerRadius: CGFloat = 10
    static let lineWidth: CGFloat = 2
    static let fontSize: CGFloat = 32
    static let fontScale: CGFloat = 1.3
    static let paddingValue: CGFloat = 3
    static let opacityValue: CGFloat = 0.5
    static let unDealtwidth: CGFloat = 61
    static let unDealtHeight: CGFloat = 90
    static let totalDealDuration: CGFloat = 3
    static let dealDuration: CGFloat = 0.5
    
}

private func scale(thatFits size: CGSize) -> CGFloat {
    min(size.width, size.height) / DrawingConstants.fontSize / DrawingConstants.fontScale
}











struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        game.choose(game.cards.first!)
        return EmojiMemoryGameView(game: game)
//            .preferredColorScheme(.light)
            .preferredColorScheme(.dark)
            .previewDevice("iPhone 13 mini")
            .previewInterfaceOrientation(.portrait)
            
            
    }
}
