//
//  TodayView.swift
//  Todo_hackathon
//
//  Created by Radhika on 21/02/26.
//

import SwiftUI

struct TodayView: View {
    @State private var showAddTask = false
    @StateObject var viewModel : TodayViewModel

    var body: some View {
        ZStack(alignment: .bottomTrailing) {

            VStack(spacing: 0) {

                header

                if viewModel.openTasks.isEmpty && viewModel.completedTasks.isEmpty {
                    emptyState
                } else {
                    taskList
                }
            }
            .safeAreaInset(edge: .bottom, alignment: .trailing) {
                addButton
            }
            .sheet(isPresented: $showAddTask) {
                AddTaskView(onSave: { taskList in
                    showAddTask = false
                    viewModel.add(taskList: taskList)
                    Haptics.success()
                })
            }

        }
    }
}

private extension TodayView {
    var header: some View {
        VStack(spacing: 8) {
            Text("Today")
                .font(.largeTitle.bold())
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(10)

            Divider()
                .overlay(Color(uiColor: .separator))
        }
        .padding(20)
    }
}

private extension TodayView {

    var taskList: some View {
        List {
            // Active Tasks
            if !viewModel.openTasks.isEmpty {
                Section {
                    ForEach(viewModel.openTasks, id: \.self) { task in
                        TaskRowView(
                            title: task.taskName ?? "",
                            isCompleted: false,
                            onToggle: {
                                viewModel.toggle(task)
                            },
                            onDelete: {
                                viewModel.delete(task)
                            }
                        ).listRowSeparator(.hidden)
                    }
                }
            }

            // Completed Tasks
            if !viewModel.completedTasks.isEmpty {
                Section(
                    header: completedHeader
                ){
                    ForEach(viewModel.completedTasks, id: \.self) { task in
                        TaskRowView(
                            title: task.taskName ?? "",
                            isCompleted: true,
                            onToggle: {
                                viewModel.toggle(task)
                            },
                            onDelete: {
                               
                            }
                        )
                        .opacity(0.7)
                        .listRowSeparator(.hidden)
                    }
                }
            }
        }
        .listStyle(.plain)
        .padding(.horizontal, 15)
    }
    
    private var completedHeader: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Completed")
                .font(.headline)
                .padding(.bottom, 5)

            Divider()
                .overlay(Color(uiColor: .separator))
        }
        .textCase(nil)
    }
}

private extension TodayView {

    struct TaskRowView: View {

        let title: String
        let isCompleted: Bool
        let onToggle: () -> Void
        let onDelete: () -> Void

        var body: some View {
            HStack(spacing: 12) {
                HStack(spacing: 12) {

                    Image(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
                        .font(.system(size: 22))
                        .foregroundColor(isCompleted ? .green : .secondary)
                        .scaleEffect(isCompleted ? 1.1 : 1.0)
                        .opacity(isCompleted ? 1 : 0.85)
                        .animation(.spring(response: 0.25, dampingFraction: 0.70), value: isCompleted)

                    Text(title)
                        .foregroundColor(isCompleted ? .secondary : .primary)
                        .strikethrough(isCompleted, color: .secondary)
                        .animation(.easeInOut(duration: 0.2), value: isCompleted)

                }
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation(.spring(response: 0.25, dampingFraction: 0.7)) {
                        onToggle()
                    }
                    Haptics.taskToggled()
                }
            }
            .swipeActions(edge: .trailing) {
                if isCompleted == false{
                    Button(role: .destructive) {
                        onDelete()
                        Haptics.taskDeleted()
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
        }
    }
}

private extension TodayView {
    var emptyState: some View {
        VStack(spacing: 12) {
            Spacer()

            Image(systemName: "checkmark.circle")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)

            Text("No tasks today")
                .font(.headline)

            Text("Add something you want to accomplish.")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Spacer()
        }
    }
}

private extension TodayView {
    var addButton: some View {
        Button(action: {
            showAddTask = true
        }) {
            Image(systemName: "plus")
                .font(.title2.bold())
                .frame(width: 56, height: 56)
                .background(.blue)
                .foregroundStyle(.white)
                .clipShape(Circle())
                .shadow(radius: 4)
        }
        .padding()
    }
}








