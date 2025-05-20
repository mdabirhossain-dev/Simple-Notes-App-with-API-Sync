//
// 
// FileName: WelcomeElement.swift
// ProjectName: Simple Notes App with API Sync
//
// Created by MD ABIR HOSSAIN on 20-05-2025 at 2:24 PM
// Website: https://mdabirhossain.com/
//



// MARK: - WelcomeElement
struct NotesModel: Codable {
    let userID, id: Int
    let title, body: String

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id, title, body
    }
}

typealias Welcome = [NotesModel]
