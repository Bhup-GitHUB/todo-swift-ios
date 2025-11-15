import Foundation
import SwiftUI

class TodoViewModel: ObservableObject {
    @Published var todos: [TodoItem] = []
    @Published var searchText: String = ""
    @Published var selectedCategory: String = "All"
    @Published var filterPriority: Priority? = nil
    @Published var showCompleted: Bool = true
    
    private let dataManager = DataManager.shared
    
    init() {
        loadTodos()
        // Add sample data only if no saved data exists
        if todos.isEmpty {
            addSampleData()
        }
    }
    
    // MARK: - Data Persistence
    
    private func saveTodos() {
        dataManager.saveTodos(todos)
    }
    
    private func loadTodos() {
        todos = dataManager.loadTodos()
    }
    
    private func addSampleData() {
        todos = [
            TodoItem(title: "Welcome to Todo App", category: "General", priority: .medium),
            TodoItem(title: "Tap to mark as complete", category: "General", priority: .low),
            TodoItem(title: "Swipe to delete", category: "General", priority: .low, isCompleted: true)
        ]
        saveTodos()
    }
    
    // MARK: - CRUD Operations
    
    func addTodo(title: String, category: String = "General", dueDate: Date? = nil, priority: Priority = .medium, notes: String = "") {
        guard !title.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        let newTodo = TodoItem(title: title, category: category, dueDate: dueDate, priority: priority, notes: notes)
        todos.append(newTodo)
        saveTodos()
    }
    
    func updateTodo(_ todo: TodoItem) {
        if let index = todos.firstIndex(where: { $0.id == todo.id }) {
            todos[index] = todo
            saveTodos()
        }
    }
    
    func toggleTodo(_ todo: TodoItem) {
        if let index = todos.firstIndex(where: { $0.id == todo.id }) {
            todos[index].isCompleted.toggle()
            saveTodos()
        }
    }
    
    func deleteTodo(_ todo: TodoItem) {
        todos.removeAll { $0.id == todo.id }
        saveTodos()
    }
    
    func deleteTodo(at offsets: IndexSet) {
        todos.remove(atOffsets: offsets)
        saveTodos()
    }
    
    // MARK: - Filtering & Search
    
    var filteredTodos: [TodoItem] {
        var filtered = todos
        
        // Filter by search text
        if !searchText.isEmpty {
            filtered = filtered.filter { todo in
                todo.title.localizedCaseInsensitiveContains(searchText) ||
                todo.category.localizedCaseInsensitiveContains(searchText) ||
                todo.notes.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        // Filter by category
        if selectedCategory != "All" {
            filtered = filtered.filter { $0.category == selectedCategory }
        }
        
        // Filter by priority
        if let priority = filterPriority {
            filtered = filtered.filter { $0.priority == priority }
        }
        
        // Filter by completion status
        if !showCompleted {
            filtered = filtered.filter { !$0.isCompleted }
        }
        
        return filtered
    }
    
    var allCategories: [String] {
        let categories = Set(todos.map { $0.category })
        return ["All"] + Array(categories).sorted()
    }
}

