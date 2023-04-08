//
//  Ubuntu.swift
//  TaskPlanner
//
//  Created by Silvio Colmán on 2023-04-07.
//

import SwiftUI

// MARK: Extensión de fuente personalizada
/// Dado que vamos a utilizar una fuente "Ubuntu" en toda nuestra aplicación, definir nombres de fuentes con tamaños y pesos requerirá mucho código, por lo que crear una extensión para hacerlo es más conveniente.
enum Ubuntu {
    case light
    case bold
    case medium
    case regular
    
    var weight: Font.Weight {
        switch self {
        case .light:
            return .light
        case .bold:
            return .bold
        case .medium:
            return .medium
        case .regular:
            return .regular
        }
    }
}

extension View {
    func ubuntu(_ size: CGFloat, _ weight: Ubuntu) -> some View {
        self
            .font(.custom("Ubuntu", size: size))
            .fontWeight(weight.weight)
    }
}
