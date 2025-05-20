//
// 
// FileName: Simple_Notes_App_with_API_SyncTests.swift
// ProjectName: Simple Notes App with API Sync
//
// Created by MD ABIR HOSSAIN on 20-05-2025 at 3:40 PM
// Website: https://mdabirhossain.com/
//


import XCTest
import CoreData
@testable import Simple_Notes_App_with_API_Sync

final class Simple_Notes_App_with_API_SyncTests: XCTestCase {
    var viewModel: NotesViewModel!
    var context: NSManagedObjectContext!
    
    override func setUpWithError() throws {
        let persistenceController = PersistenceController(inMemory: true)
        context = persistenceController.container.viewContext
        viewModel = NotesViewModel(context: context)
    }

    override func tearDownWithError() throws {
        viewModel = nil
        context = nil
    }

    func testAddNoteIncreasesCount() throws {
        let initialCount = viewModel.notes.count
        viewModel.addNote(title: "Test Title", body: "Test Body")
        XCTAssertEqual(viewModel.notes.count, initialCount + 1)
    }

    func testNoDuplicateNoteAdded() throws {
        let note = NotesModel(id: 1, userID: 123, title: "Title", body: "Body")
        
        _ = viewModel.isNoteInCoreData(id: note.id ?? 0)
        let noteEntity = NoteEntity(context: context)
        noteEntity.id = Int64(note.id ?? 0)
        noteEntity.title = note.title
        noteEntity.body = note.body
        try context.save()
        
        let alreadyExists = viewModel.isNoteInCoreData(id: note.id ?? 0)
        XCTAssertTrue(alreadyExists)
    }

    func testLoadNotesFromCoreData() throws {
        let newNote = NoteEntity(context: context)
        newNote.id = 999
        newNote.title = "From CoreData"
        newNote.body = "Body"
        try context.save()

        viewModel.loadNotesFromCoreData()
        XCTAssertTrue(viewModel.notes.contains { $0.id == 999 })
    }
}
