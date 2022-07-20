//
//  Cardify.swift
//  learningApp
//
//  Created by Bijen Shrestha on 24/05/2022.
//

import SwiftUI

struct Cardify: AnimatableModifier {
    init(isFaceUp: Bool) {
        rotation = isFaceUp ? 0 : 180
    }
    
    var animatableData: Double {
        get{rotation}
        set{rotation = newValue}
    }
    
    
    var rotation: Double // in degrees
    
    func body(content: Content) -> some View {
        ZStack(content: {
            let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
            if rotation < 90{
                shape.fill(.white)
                shape.strokeBorder(lineWidth: DrawingConstants.lineWidth).foregroundColor(.red)
            } else {
                   shape.fill(.red)
            }
            content
                .opacity(rotation < 90 ? 1 : 0)
                       
       })
        .rotation3DEffect(Angle.degrees(rotation), axis: (0, 1, 0))
    }
    
    
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 10
        static let lineWidth: CGFloat = 2
    }
    
}



extension View {
    func cardify(isFaceUp: Bool) -> some View {
        self.modifier(Cardify(isFaceUp: isFaceUp))
    }
}
