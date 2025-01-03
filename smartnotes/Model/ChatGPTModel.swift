//
//  ChatGPTModel.swift
//  smartnotes
//
//  Created by admin on 27/12/24.
//

import Foundation

struct ChatMessage: Identifiable, Codable {
    let id = UUID()
    let role: String // "user" or "assistant"
    let content: String
}

struct ChatGPTRequest: Codable {
    let model: String
    let messages: [[String: String]]
    let max_tokens: Int
}

struct ChatGPTResponse: Codable {
    struct Choice: Codable {
        struct Message: Codable {
            let role: String
            let content: String
        }
        let message: Message
    }
    let choices: [Choice]
}
