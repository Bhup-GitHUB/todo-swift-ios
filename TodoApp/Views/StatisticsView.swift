import SwiftUI

struct StatisticsView: View {
    @ObservedObject var viewModel: TodoViewModel
    @Environment(\.dismiss) var dismiss
    
    var statistics: TodoStatistics {
        StatisticsManager.shared.calculateStatistics(from: viewModel.todos)
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Overview Cards
                    HStack(spacing: 16) {
                        StatCard(
                            title: "Total",
                            value: "\(statistics.totalTodos)",
                            icon: "list.bullet",
                            color: .blue
                        )
                        StatCard(
                            title: "Completed",
                            value: "\(statistics.completedTodos)",
                            icon: "checkmark.circle.fill",
                            color: .green
                        )
                        StatCard(
                            title: "Active",
                            value: "\(statistics.activeTodos)",
                            icon: "circle",
                            color: .orange
                        )
                        StatCard(
                            title: "Overdue",
                            value: "\(statistics.overdueTodos)",
                            icon: "exclamationmark.triangle.fill",
                            color: .red
                        )
                    }
                    .padding(.horizontal)
                    
                    // Completion Rate
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Completion Rate")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(.systemGray6))
                                .frame(height: 120)
                            
                            VStack(spacing: 8) {
                                Text("\(Int(statistics.completionRate))%")
                                    .font(.system(size: 48, weight: .bold))
                                    .foregroundColor(.primary)
                                
                                ProgressView(value: statistics.completionRate / 100)
                                    .progressViewStyle(.linear)
                                    .tint(.blue)
                                    .scaleEffect(x: 1, y: 2, anchor: .center)
                                    .padding(.horizontal, 32)
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // Streaks
                    HStack(spacing: 16) {
                        StreakCard(
                            title: "Current Streak",
                            value: "\(statistics.currentStreak)",
                            icon: "flame.fill",
                            color: .orange
                        )
                        StreakCard(
                            title: "Longest Streak",
                            value: "\(statistics.longestStreak)",
                            icon: "star.fill",
                            color: .yellow
                        )
                    }
                    .padding(.horizontal)
                    
                    // Priority Distribution
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Priority Distribution")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        VStack(spacing: 12) {
                            ForEach(Priority.allCases, id: \.self) { priority in
                                HStack {
                                    HStack(spacing: 8) {
                                        Image(systemName: priority.icon)
                                            .foregroundColor(priority.color)
                                        Text(priority.rawValue)
                                            .font(.subheadline)
                                    }
                                    
                                    Spacer()
                                    
                                    Text("\(statistics.todosByPriority[priority] ?? 0)")
                                        .font(.headline)
                                    
                                    ProgressView(value: Double(statistics.todosByPriority[priority] ?? 0), total: Double(statistics.totalTodos))
                                        .progressViewStyle(.linear)
                                        .frame(width: 100)
                                        .tint(priority.color)
                                }
                                .padding(.horizontal)
                            }
                        }
                        .padding(.vertical, 12)
                        .background(Color(.systemGray6))
                        .cornerRadius(16)
                        .padding(.horizontal)
                    }
                    
                    // Category Distribution
                    if !statistics.todosByCategory.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Category Distribution")
                                .font(.headline)
                                .padding(.horizontal)
                            
                            VStack(spacing: 8) {
                                ForEach(Array(statistics.todosByCategory.keys.sorted()), id: \.self) { category in
                                    HStack {
                                        Text(category)
                                            .font(.subheadline)
                                        
                                        Spacer()
                                        
                                        Text("\(statistics.todosByCategory[category] ?? 0)")
                                            .font(.headline)
                                        
                                        ProgressView(value: Double(statistics.todosByCategory[category] ?? 0), total: Double(statistics.totalTodos))
                                            .progressViewStyle(.linear)
                                            .frame(width: 100)
                                            .tint(.blue)
                                    }
                                    .padding(.horizontal)
                                }
                            }
                            .padding(.vertical, 12)
                            .background(Color(.systemGray6))
                            .cornerRadius(16)
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Statistics")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct StreakCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 32))
                .foregroundColor(color)
            
            Text(value)
                .font(.system(size: 36, weight: .bold))
            
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
}

struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsView(viewModel: TodoViewModel())
    }
}

