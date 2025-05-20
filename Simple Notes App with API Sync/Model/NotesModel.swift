//
// 
// FileName: NotesModel.swift
// ProjectName: Simple Notes App with API Sync
//
// Created by MD ABIR HOSSAIN on 20-05-2025 at 2:24 PM
// Website: https://mdabirhossain.com/
//

import Foundation

typealias Notes = [NotesModel]
 
struct NotesModel: Codable {
    let id: Int?
    let userID: Int?
    let title: String?
    let body: String?

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id, title, body
    }
}

