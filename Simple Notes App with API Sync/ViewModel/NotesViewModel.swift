//
//
// FileName: NotesViewModel.swift
// ProjectName: Simple Notes App with API Sync
//
// Created by MD ABIR HOSSAIN on 20-05-2025 at 2:27 PM
// Website: https://mdabirhossain.com/
//


import SwiftUI
import CoreData

class NotesViewModel: ObservableObject {
    @AppStorage("lastSyncTime") private var lastSyncTime: String = ""
    @Published var notes: [NotesModel] = []
    @Published var isSynching: Bool = false
    @Published var syncStatus: String = ""
    
    private var context: NSManagedObjectContext
    private var syncTime: Date? {
        get {
            ISO8601DateFormatter().date(from: lastSyncTime)
        }
        set {
            if let newValue = newValue {
                lastSyncTime = ISO8601DateFormatter().string(from: newValue)
            }
        }
    }
    
    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.context = context
        loadNotesFromCoreData()
    }
    
    @MainActor func fetchNotes() async {
        DispatchQueue.main.async {
            self.syncStatus = "Syncing..."
            self.isSynching = true
        }
        
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let fetchedNotes = try JSONDecoder().decode([NotesModel].self, from: data)
            
            for note in fetchedNotes {
                if !isNoteInCoreData(id: note.id ?? 0) {
                    let newNote = NoteEntity(context: context)
                    newNote.id = Int64(note.id ?? 0)
                    newNote.userID = Int64(note.userID ?? 0)
                    newNote.title = note.title
                    newNote.body = note.body
                }
            }
            try context.save()
            loadNotesFromCoreData()
            syncTime = Date()
            
            syncStatus = "Synced!"
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                self?.isSynching = false
            }
        } catch {
            print("Failed to fetch or save notes: \(error)")
        }
    }
    
    func isNoteInCoreData(id: Int) -> Bool {
        let request = NoteEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", id)
        let result = try? context.fetch(request)
        return (result?.first != nil)
    }
    
    func loadNotesFromCoreData() {
        let request = NoteEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \NoteEntity.id, ascending: true)]
        if let result = try? context.fetch(request) {
            notes = result.map {
                NotesModel(id: Int($0.id), userID: Int($0.userID), title: $0.title, body: $0.body)
            }
        }
    }
    
    func addNote(title: String, body: String) {
        let newId = (notes.last?.id ?? 0) + 1
        let newNote = NoteEntity(context: context)
        newNote.id = Int64(newId)
        newNote.title = title
        newNote.body = body
        newNote.userID = 0
        try? context.save()
        loadNotesFromCoreData()
    }
    
    func editNote(id: Int, newTitle: String, newBody: String) {
        let fetchRequest: NSFetchRequest<NoteEntity> = NoteEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        
        do {
            if let entity = try context.fetch(fetchRequest).first {
                entity.title = newTitle
                entity.body = newBody
                try context.save()
                loadNotesFromCoreData()
            }
        } catch {
            print("Failed to edit note: \(error)")
        }
    }
    
    
    func deleteNote(at offsets: IndexSet) {
        for index in offsets {
            let note = notes[index]
            let request = NoteEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %d", note.id ?? 0)
            if let result = try? context.fetch(request), let entity = result.first {
                context.delete(entity)
            }
        }
        try? context.save()
        loadNotesFromCoreData()
    }
}
