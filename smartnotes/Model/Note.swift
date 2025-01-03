//
//  Note.swift
//  smartnotes
//
//  Created by admin on 06/12/24.
//

import Foundation
import SwiftData

@Model
class Note: Identifiable {
    var id: UUID
    var createdAt: Date
    var title: String
    var content: String
    var isFavorite: Bool
    
    init(title: String, content: String, isFavorite: Bool) {
        self.id = UUID()
        self.createdAt = Date()
        self.title = title
        self.content = content
        self.isFavorite = isFavorite
    }
    
    static let sampleData = [
        Note(title: "Note 1", content: "Content 1", isFavorite: false),
        Note(title: "Note 2", content: "Content 2", isFavorite: false),
        Note(title: "Note 3", content: "Content 3", isFavorite: false),
        Note(title: "Note 4", content: "Content 4", isFavorite: false),
        Note(title: "Note 5", content: "Content 5", isFavorite: false),
        Note(title: "Note 6", content: "Content 6", isFavorite: false),
        Note(title: "Note 7", content: "Content 7", isFavorite: false),
        Note(title: "Note 8", content: "Content 8", isFavorite: false),
    ]
}
