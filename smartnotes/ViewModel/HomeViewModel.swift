//
//  HomeViewModel.swift
//  smartnotes
//
//  Created by admin on 18/12/24.
//

import Foundation
import SwiftUI
import SwiftData

@Observable
final class HomeViewModel {
    var searchText: String = ""
    var selectedCategory: Category = .all
    
    func filterNotes(_ notes: [Note]) -> [Note] {
        let categoryFiltered = switch selectedCategory {
        case .all:
            notes
        case .favorites:
            notes.filter { $0.isFavorite }
        }
        
        if searchText.isEmpty {
            return categoryFiltered
        }
        
        return categoryFiltered.filter { note in
            note.title.localizedCaseInsensitiveContains(searchText) ||
            note.content.localizedCaseInsensitiveContains(searchText)
        }
    }
}
