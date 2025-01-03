//
//  NoteViewModel.swift
//  smartnotes
//
//  Created by admin on 18/12/24.
//

import Foundation
import SwiftUI
import SwiftData

@Observable
final class NoteViewModel {
    var title: String
    var content: String
    var isFavorite: Bool
    var isAiSheetPresented: Bool = false
    private var existingNote: Note?

    private let apiKey = "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"
    private let baseUrl = "https://api.openai.com/v1/chat/completions"
    var isLoadingAiResponse: Bool = false
    var aiError: Error?
    var aiPrompt: String = ""
    var messages: [ChatMessage] = []
    
    init(note: Note? = nil) {
        if let note = note {
            self.title = note.title
            self.content = note.content
            self.isFavorite = note.isFavorite
            self.existingNote = note
        } else {
            self.title = ""
            self.content = ""
            self.isFavorite = false
        }
    }

    func sendMessage(_ userMessage: String) {
        guard !userMessage.isEmpty else { return }
        
        let userChatMessage = ChatMessage(role: "user", content: userMessage)
        messages.append(userChatMessage)
        
        let requestMessages = messages.map { ["role": $0.role, "content": $0.content] }
        let requestBody = ChatGPTRequest(model: "gpt-4", messages: requestMessages, max_tokens: 150)
        
        guard let url = URL(string: baseUrl) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(requestBody)
        } catch {
            print("Error encoding request: \(error)")
            return
        }
        
        isLoadingAiResponse = true
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self, let data = data, error == nil else {
                DispatchQueue.main.async {
                    self?.isLoadingAiResponse = false
                    self?.aiError = error
                }
                return
            }
            
            do {
                let apiResponse = try JSONDecoder().decode(ChatGPTResponse.self, from: data)
                if let messageContent = apiResponse.choices.first?.message.content {
                    DispatchQueue.main.async {
                        self.content += !self.content.isEmpty ? "\n\n\(messageContent)" : messageContent
                        
                        let assistantMessage = ChatMessage(role: "assistant", content: messageContent)
                        self.messages.append(assistantMessage)
                        
                        self.aiPrompt = ""
                        self.isLoadingAiResponse = false
                        self.isAiSheetPresented = false
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.isLoadingAiResponse = false
                    self.aiError = error
                }
                print("Error decoding response: \(error)")
            }
        }.resume()
    }
    
    func saveNote(context: ModelContext) {
        if let existingNote = existingNote {
            existingNote.title = title
            existingNote.content = content
            existingNote.isFavorite = isFavorite
        } else {
            guard !title.isEmpty || !content.isEmpty else { return }
            let newNote = Note(title: title, content: content, isFavorite: isFavorite)
            context.insert(newNote)
        }
        
        do {
            try context.save()
        } catch {
            print("Error saving note: \(error)")
        }
    }
    

    func toggleFavorite() {
        isFavorite.toggle()
    }

}
