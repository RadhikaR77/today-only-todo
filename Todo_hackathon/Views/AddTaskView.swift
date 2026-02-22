//
//  AddTaskView.swift
//  Todo_hackathon
//
//  Created by Radhika on 21/02/26.
//
import SwiftUI

struct DraftTask: Identifiable, Hashable {
    let id = UUID()
    var text: String = ""
}

struct AddTaskView: View {

    @State private var drafts: [DraftTask] = [DraftTask()]
    // Controls keyboard focus across dynamic rows
    @FocusState private var focusedID: UUID?

    var onSave: ([String]) -> Void

    var body: some View {
        NavigationStack {
            List {
                ForEach($drafts) { $draft in
                    TextField("New task", text: $draft.text)
                        .focused($focusedID, equals: draft.id)
                        .submitLabel(.done)
                        .onSubmit {
                            handleSubmit(for: draft.id)
                        }
                }
            }
            .navigationTitle("Add Tasks")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        saveTasks()
                    }
                }
            }
            .onAppear {
                focusedID = drafts.last?.id
            }
        }
    }
    
    private func handleSubmit(for id: UUID) {

        guard let index = drafts.firstIndex(where: { $0.id == id }) else { return }

        let trimmed = drafts[index].text.trimmingCharacters(in: .whitespaces)

        // If empty → dismiss keyboard
        guard !trimmed.isEmpty else {
            focusedID = nil
            return
        }

        // If user presses return on last row -> create next input
        if index == drafts.count - 1 {
            drafts.append(DraftTask())
        }

        // Move focus to next row
        DispatchQueue.main.async {
            focusedID = drafts[index + 1].id
        }
    }
    
    private func saveTasks() {
        let tasks = drafts
            .map { $0.text.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }

        onSave(tasks)
    }
}


