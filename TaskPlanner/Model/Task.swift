//
//  Task.swift
//  TaskPlanner
//
//  Created by Silvio Colmán on 2023-04-07.
//

import SwiftUI

// MARK: Task Model
struct Task: Identifiable {
    var id: UUID = .init()
    var dateAdded: Date
    var taskName: String
    var taskDescription: String
    var taskCategory: Category
}

/// - Muestras Tareas
let startDate = DateComponents(year: 2023, month: 4, day: 5).date!
let secondDate = DateComponents(year: 2023, month: 4, day: 6).date!
let endDate = DateComponents(year: 2023, month: 4, day: 7).date!

var sampleTasks: [Task] = [
    .init(dateAdded: Date(timeIntervalSince1970: 1680870416), taskName: "Edit YT Video", taskDescription: "Hoy debo editar un video de la clase", taskCategory: .general),
    .init(dateAdded: Date(timeIntervalSince1970: 1680902816), taskName: "Matched Geometry Effect (Issue)", taskDescription: "", taskCategory: .bug),
    .init(dateAdded: Date(timeIntervalSince1970: 1680654416), taskName: "Multi-ScrollView", taskDescription: "", taskCategory: .challenge),
    .init(dateAdded: Date(timeIntervalSince1970: 1680740816), taskName: "Complete UI Animation Challenge", taskDescription: "", taskCategory: .challenge),
    .init(dateAdded: Date(timeIntervalSince1970: 1680913616), taskName: "Fix Shadow issue on Mockup's", taskDescription: "", taskCategory: .bug),
]
