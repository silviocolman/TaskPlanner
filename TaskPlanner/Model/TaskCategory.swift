//
//  TaskCategory.swift
//  TaskPlanner
//
//  Created by Silvio Colmán on 2023-04-07.
//

import SwiftUI

// MARK: Categoría Enum con Color
enum Category: String, CaseIterable {
    /// - Añada aquí su propio tipo de categoría con un color.
    case general = "General"
    case bug = "Bug"
    case idea = "Idea"
    case modifiers = "Modifiers"
    case challenge = "Challenge"
    case coding = "Coding"
    
    var color: Color {
        switch self {
        case .general:
            return Color("Gray")
        case .bug:
            return Color("Green")
        case .idea:
            return Color("Pink")
        case .modifiers:
            return Color("Blue")
        case .challenge:
            return Color.purple
        case .coding:
            return Color.brown
        }
    }
}
