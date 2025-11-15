import Foundation
import SwiftUI

class TodoViewModel: ObservableObject {
    @Published var todos: [TodoItem] = []
    
    init() {
        // Initialize with some sample data for testing
        todos = [
            TodoItem(title: "Welcome to Todo App", isCompleted: false),
            TodoItem(title: "Tap to mark as complete", isCompleted: false),
            TodoItem(title: "Swipe to delete", isCompleted: true)
        ]
    }
    
    // MARK: - CRUD Operations
    
    func addTodo(title: String) {
        guard !title.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        let newTodo = TodoItem(title: title)
        todos.append(newTodo)
    }
    
    func toggleTodo(_ todo: TodoItem) {
        if let index = todos.firstIndex(where: { $0.id == todo.id }) {
            todos[index].isCompleted.toggle()
        }
    }
    
    func deleteTodo(_ todo: TodoItem) {
        todos.removeAll { $0.id == todo.id }
    }
    
    func deleteTodo(at offsets: IndexSet) {
        todos.remove(atOffsets: offsets)
    }
}

