import Foundation

struct TodoStatistics {
    let totalTodos: Int
    let completedTodos: Int
    let activeTodos: Int
    let overdueTodos: Int
    let completionRate: Double
    let currentStreak: Int
    let longestStreak: Int
    let todosByPriority: [Priority: Int]
    let todosByCategory: [String: Int]
}

class StatisticsManager {
    static let shared = StatisticsManager()
    
    private init() {}
    
    func calculateStatistics(from todos: [TodoItem]) -> TodoStatistics {
        let totalTodos = todos.count
        let completedTodos = todos.filter { $0.isCompleted }.count
        let activeTodos = todos.filter { !$0.isCompleted }.count
        let overdueTodos = todos.filter { $0.isOverdue && !$0.isCompleted }.count
        
        let completionRate = totalTodos > 0 ? Double(completedTodos) / Double(totalTodos) * 100 : 0.0
        
        // Calculate streaks
        let sortedTodos = todos.sorted { $0.createdAt > $1.createdAt }
        let currentStreak = calculateCurrentStreak(from: sortedTodos)
        let longestStreak = calculateLongestStreak(from: sortedTodos)
        
        // Group by priority
        var todosByPriority: [Priority: Int] = [:]
        for priority in Priority.allCases {
            todosByPriority[priority] = todos.filter { $0.priority == priority }.count
        }
        
        // Group by category
        var todosByCategory: [String: Int] = [:]
        for category in Set(todos.map { $0.category }) {
            todosByCategory[category] = todos.filter { $0.category == category }.count
        }
        
        return TodoStatistics(
            totalTodos: totalTodos,
            completedTodos: completedTodos,
            activeTodos: activeTodos,
            overdueTodos: overdueTodos,
            completionRate: completionRate,
            currentStreak: currentStreak,
            longestStreak: longestStreak,
            todosByPriority: todosByPriority,
            todosByCategory: todosByCategory
        )
    }
    
    private func calculateCurrentStreak(from todos: [TodoItem]) -> Int {
        var streak = 0
        var currentDate = Calendar.current.startOfDay(for: Date())
        
        for todo in todos where todo.isCompleted {
            let todoDate = Calendar.current.startOfDay(for: todo.createdAt)
            if todoDate == currentDate {
                streak += 1
                currentDate = Calendar.current.date(byAdding: .day, value: -1, to: currentDate) ?? currentDate
            } else if todoDate < currentDate {
                break
            }
        }
        
        return streak
    }
    
    private func calculateLongestStreak(from todos: [TodoItem]) -> Int {
        let completedTodos = todos.filter { $0.isCompleted }
        guard !completedTodos.isEmpty else { return 0 }
        
        var longestStreak = 0
        var currentStreak = 0
        var previousDate: Date?
        
        for todo in completedTodos.sorted(by: { $0.createdAt > $1.createdAt }) {
            let todoDate = Calendar.current.startOfDay(for: todo.createdAt)
            
            if let prevDate = previousDate {
                let daysDifference = Calendar.current.dateComponents([.day], from: todoDate, to: prevDate).day ?? 0
                
                if daysDifference == 1 {
                    currentStreak += 1
                } else if daysDifference > 1 {
                    longestStreak = max(longestStreak, currentStreak)
                    currentStreak = 1
                } else {
                    currentStreak = max(currentStreak, 1)
                }
            } else {
                currentStreak = 1
            }
            
            previousDate = todoDate
            longestStreak = max(longestStreak, currentStreak)
        }
        
        return longestStreak
    }
}

