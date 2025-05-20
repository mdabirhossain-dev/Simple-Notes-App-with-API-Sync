//
// 
// FileName: Simple_Notes_App_with_API_SyncApp.swift
// ProjectName: Simple Notes App with API Sync
//
// Created by MD ABIR HOSSAIN on 20-05-2025 at 2:21 PM
// Website: https://mdabirhossain.com/
//


import SwiftUI

@main
struct Simple_Notes_App_with_API_SyncApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
