//
//
// FileName: HomeView.swift
// ProjectName: Simple Notes App with API Sync
//
// Created by MD ABIR HOSSAIN on 20-05-2025 at 2:21 PM
// Website: https://mdabirhossain.com/
//


import SwiftUI
import CoreData

struct HomeView: View {
    @StateObject private var viewModel = NotesViewModel()
    @State private var showAddNotePopup = false
    @State private var newTitle = ""
    @State private var newBody = ""
    
    @State private var isEditing = false
    @State private var editingNote: NotesModel?
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(viewModel.notes, id: \..id) { note in
                        HStack {
                            VStack(alignment: .leading) {
                                Text((note.title ?? "No Title").prefix(50) + ((note.title?.count ?? 0) > 50 ? "..." : ""))
                                    .font(.headline)
                                
                                Text((note.body ?? "No Body").prefix(50) + ((note.body?.count ?? 0) > 50 ? "..." : ""))
                                    .font(.subheadline)
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                editingNote = note
                                newTitle = note.title ?? ""
                                newBody = note.body ?? ""
                                isEditing = true
                            }) {
                                Image(systemName: "square.and.pencil")
                                    .font(.system(size: 26, weight: .bold))
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .onDelete(perform: viewModel.deleteNote)
                }
                if let syncTime = viewModel.lastSyncTime {
                    Text("Last synced time: \(syncTime.formatted(date: .abbreviated, time: .shortened))")
                        .font(.footnote)
                        .padding(3)
                        .background(Color.blue.opacity(0.5))
                        .cornerRadius(5)
                        .padding(.vertical, 4)
                }
            }
            .navigationTitle("Notes")
            .overlay(
                ZStack {
                    if viewModel.isSynching {
                        Color.gray.opacity(0.7)
                            .ignoresSafeArea(.all)
                        
                        ProgressView(viewModel.syncStatus)
                            .tint(.red)
                            .controlSize(.large)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(5)
                    }
                }
            )
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showAddNotePopup = true
                    }) {
                        Text("+")
                            .font(.system(size: 26, weight: .bold))
                            .padding()
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Sync") {
                        Task {
                            await viewModel.fetchNotes()
                        }
                    }
                }
            }
            .sheet(isPresented: $showAddNotePopup) {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Add New Note")
                        .font(.title2)
                        .bold()
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Title")
                            .font(.headline)
                        TextEditor(text: $newTitle)
                            .frame(height: 60)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5)))
                        
                        Text("Body")
                            .font(.headline)
                        TextEditor(text: $newBody)
                            .frame(height: 150)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5)))
                    }
                    
                    Button(action: {
                        viewModel.addNote(title: newTitle, body: newBody)
                        newTitle = ""
                        newBody = ""
                        showAddNotePopup = false
                    }) {
                        Text("Save")
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                    Spacer()
                }
                .padding()
            }
            .sheet(isPresented: $isEditing) {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Edit Note")
                        .font(.title2)
                        .bold()
                    
                    Text("Title")
                        .font(.headline)
                    TextEditor(text: $newTitle)
                        .frame(height: 60)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5)))
                    
                    Text("Body")
                        .font(.headline)
                    TextEditor(text: $newBody)
                        .frame(height: 150)
                        .overlay(RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.5)))
                    
                    Button("Save Changes") {
                        if let note = editingNote {
                            viewModel.editNote(id: note.id ?? 0, newTitle: newTitle, newBody: newBody)
                        }
                        newTitle = ""
                        newBody = ""
                        editingNote = nil
                        isEditing = false
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    
                    Spacer()
                }
                .padding()
                .onDisappear {
                    newTitle = ""
                    newBody = ""
                }
            }
            .onAppear {
                viewModel.loadNotesFromCoreData()
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

#Preview {
    HomeView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
