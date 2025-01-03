//
//  smartnotesApp.swift
//  smartnotes
//
//  Created by admin on 06/12/24.
//

import SwiftUI
import SwiftData

@main
struct smartnotesApp: App {
    let container: ModelContainer
        
        init() {
            do {
                container = try ModelContainer(for: Note.self)
            } catch {
                fatalError("Could not initialize ModelContainer")
            }
        }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                Onboarding()
            }
        }
        .modelContainer(container)
    }
}
