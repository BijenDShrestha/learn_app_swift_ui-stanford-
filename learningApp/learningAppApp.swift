//
//  learningAppApp.swift
//  learningApp
//
//  Created by Bijen Shrestha on 26/04/2022.
//

import SwiftUI

@main
struct learningAppApp: App {
    private let game = EmojiMemoryGame()
    
    var body: some Scene {
        WindowGroup {
            EmojiMemoryGameView(game: game)
        }
    }
}
