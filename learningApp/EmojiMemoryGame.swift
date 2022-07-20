//
//  EmojiMemoryGame.swift
//  learningApp
//
//  Created by Bijen Shrestha on 08/05/2022.
//

import SwiftUI

//func makeCardContent(index: Int) -> String {
//    return "😃"
//}



class EmojiMemoryGame: ObservableObject {
    typealias Card = MemoryGame<String>.Card
    
    private static let emojis: Array<String> = ["🚍", "✈️", "🚗", "🛳", "🏊‍♂️", "🧘‍♂️", "🏥", "🏄‍♀️", "🧗🏿‍♂️", "😄", "😗", "🎽", "🤾🏿", "🎮", "🎳", "🏆", "🥅"]
    
    private static func CreateMemoryGame() -> MemoryGame<String>{
        MemoryGame<String>(numberOfPairsOfCards: 8){ pairIndex in
        EmojiMemoryGame.emojis[pairIndex]
        }
    }
    
    @Published private var model = CreateMemoryGame()
   
    
    var cards: Array<Card> {
        model.cards
    }
    
    // MARK: - Intent(s)
    func choose(_ card: Card) {
//        objectWillChange.send()
        model.choose(card)
    }
    
    func shuffle() {
        model.shuffle()
    }
    
    func restart() {
        model = EmojiMemoryGame.CreateMemoryGame()
    }
    
}

