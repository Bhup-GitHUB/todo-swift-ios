import Foundation

class DataManager {
    static let shared = DataManager()
    private let todosKey = "savedTodos"
    
    private init() {}
    
    // MARK: - Save & Load
    
    func saveTodos(_ todos: [TodoItem]) {
        if let encoded = try? JSONEncoder().encode(todos) {
            UserDefaults.standard.set(encoded, forKey: todosKey)
        }
    }
    
    func loadTodos() -> [TodoItem] {
        guard let data = UserDefaults.standard.data(forKey: todosKey),
              let decoded = try? JSONDecoder().decode([TodoItem].self, from: data) else {
            return []
        }
        return decoded
    }
    
    func clearTodos() {
        UserDefaults.standard.removeObject(forKey: todosKey)
    }
}

