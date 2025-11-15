import SwiftUI

struct TodoListView: View {
    @ObservedObject var viewModel: TodoViewModel
    @State private var showingAddTodo = false
    @State private var showingFilters = false
    @State private var showingStatistics = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search Bar
                SearchBar(text: $viewModel.searchText)
                
                // Filter Chips
                if viewModel.allCategories.count > 1 || viewModel.filterPriority != nil || !viewModel.showCompleted {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            // Category Filter
                            if viewModel.allCategories.count > 1 {
                                Menu {
                                    ForEach(viewModel.allCategories, id: \.self) { category in
                                        Button(action: {
                                            viewModel.selectedCategory = category
                                        }) {
                                            HStack {
                                                Text(category)
                                                if viewModel.selectedCategory == category {
                                                    Image(systemName: "checkmark")
                                                }
                                            }
                                        }
                                    }
                                } label: {
                                    FilterChip(
                                        title: viewModel.selectedCategory == "All" ? "Category" : viewModel.selectedCategory,
                                        icon: "folder.fill"
                                    )
                                }
                            }
                            
                            // Priority Filter
                            Menu {
                                Button("All Priorities") {
                                    viewModel.filterPriority = nil
                                }
                                ForEach(Priority.allCases, id: \.self) { priority in
                                    Button(action: {
                                        viewModel.filterPriority = viewModel.filterPriority == priority ? nil : priority
                                    }) {
                                        HStack {
                                            Image(systemName: priority.icon)
                                            Text(priority.rawValue)
                                            if viewModel.filterPriority == priority {
                                                Image(systemName: "checkmark")
                                            }
                                        }
                                    }
                                }
                            } label: {
                                FilterChip(
                                    title: viewModel.filterPriority?.rawValue ?? "Priority",
                                    icon: "exclamationmark.circle.fill"
                                )
                            }
                            
                            // Completed Toggle
                            Button(action: {
                                viewModel.showCompleted.toggle()
                            }) {
                                FilterChip(
                                    title: viewModel.showCompleted ? "Show All" : "Active Only",
                                    icon: viewModel.showCompleted ? "eye.fill" : "eye.slash.fill"
                                )
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical, 8)
                }
                
                // Todo List
                ZStack {
                    if viewModel.filteredTodos.isEmpty {
                        EmptyStateView(hasFilters: !viewModel.searchText.isEmpty || viewModel.selectedCategory != "All" || viewModel.filterPriority != nil)
                    } else {
                        List {
                            ForEach(viewModel.filteredTodos) { todo in
                                TodoRowView(viewModel: viewModel, todo: todo) {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        viewModel.toggleTodo(todo)
                                    }
                                }
                                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                    Button(role: .destructive) {
                                        withAnimation(.spring()) {
                                            viewModel.deleteTodo(todo)
                                        }
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                    
                                    Button {
                                        withAnimation(.spring()) {
                                            var updatedTodo = todo
                                            updatedTodo.isCompleted.toggle()
                                            viewModel.updateTodo(updatedTodo)
                                        }
                                    } label: {
                                        Label(todo.isCompleted ? "Undo" : "Complete", systemImage: todo.isCompleted ? "arrow.uturn.backward" : "checkmark")
                                    }
                                    .tint(todo.isCompleted ? .orange : .green)
                                }
                                .swipeActions(edge: .leading, allowsFullSwipe: false) {
                                    Button {
                                        // Quick edit - could open edit view
                                    } label: {
                                        Label("Edit", systemImage: "pencil")
                                    }
                                    .tint(.blue)
                                }
                            }
                            .onDelete { indexSet in
                                withAnimation(.spring()) {
                                    let todosToDelete = indexSet.map { viewModel.filteredTodos[$0] }
                                    for todo in todosToDelete {
                                        viewModel.deleteTodo(todo)
                                    }
                                }
                            }
                        }
                        .listStyle(.insetGrouped)
                        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: viewModel.filteredTodos.count)
                    }
                }
            }
            .navigationTitle("My Todos")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack(spacing: 12) {
                        Button(action: {
                            showingStatistics.toggle()
                        }) {
                            Image(systemName: "chart.bar.fill")
                                .font(.title2)
                        }
                        
                        Button(action: {
                            showingFilters.toggle()
                        }) {
                            Image(systemName: "line.3.horizontal.decrease.circle")
                                .font(.title2)
                        }
                    }
                }
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Menu {
                        Button(action: {
                            shareTodos()
                        }) {
                            Label("Export Todos", systemImage: "square.and.arrow.up")
                        }
                        
                        Button(action: {
                            showingAddTodo = true
                        }) {
                            Label("Add Todo", systemImage: "plus.circle")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle.fill")
                            .font(.title2)
                    }
                    
                    Button(action: {
                        withAnimation(.spring()) {
                            showingAddTodo = true
                        }
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $showingAddTodo) {
                AddTodoView(viewModel: viewModel)
            }
            .sheet(isPresented: $showingFilters) {
                FilterView(viewModel: viewModel)
            }
            .sheet(isPresented: $showingStatistics) {
                StatisticsView(viewModel: viewModel)
            }
        }
    }
    
    private func shareTodos() {
        let todosText = viewModel.todos.map { todo in
            let status = todo.isCompleted ? "✅" : "⭕"
            let priority = todo.priority.rawValue
            let category = todo.category
            let dueDate = todo.dueDate != nil ? "Due: \(formatDate(todo.dueDate!))" : ""
            return "\(status) \(todo.title) [\(category)] [\(priority)] \(dueDate)"
        }.joined(separator: "\n")
        
        let activityVC = UIActivityViewController(activityItems: [todosText], applicationActivities: nil)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            rootViewController.present(activityVC, animated: true)
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct TodoRowView: View {
    @ObservedObject var viewModel: TodoViewModel
    let todo: TodoItem
    let onToggle: () -> Void
    
    @State private var showingEditTodo = false
    
    init(viewModel: TodoViewModel? = nil, todo: TodoItem, onToggle: @escaping () -> Void) {
        self.viewModel = viewModel ?? TodoViewModel()
        self.todo = todo
        self.onToggle = onToggle
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Button(action: onToggle) {
                Image(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(todo.isCompleted ? .green : .gray)
                    .font(.title2)
            }
            .buttonStyle(.plain)
            
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(todo.title)
                        .font(.body)
                        .fontWeight(todo.priority == .high ? .semibold : .regular)
                        .strikethrough(todo.isCompleted)
                        .foregroundColor(todo.isCompleted ? .secondary : .primary)
                    
                    Spacer()
                    
                    // Priority indicator
                    Image(systemName: todo.priority.icon)
                        .foregroundColor(todo.priority.color)
                        .font(.caption)
                }
                
                HStack(spacing: 12) {
                    // Category badge
                    Text(todo.category)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.blue.opacity(0.2))
                        .foregroundColor(.blue)
                        .cornerRadius(8)
                    
                    // Due date
                    if let dueDate = todo.dueDate {
                        HStack(spacing: 4) {
                            Image(systemName: "calendar")
                                .font(.caption2)
                            Text(formatDate(dueDate))
                                .font(.caption)
                        }
                        .foregroundColor(todo.isOverdue ? .red : .secondary)
                    }
                    
                    Spacer()
                }
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(.spring()) {
                showingEditTodo = true
            }
        }
        .sheet(isPresented: $showingEditTodo) {
            EditTodoView(viewModel: viewModel, todo: todo)
        }
        .transition(.asymmetric(
            insertion: .scale.combined(with: .opacity),
            removal: .scale.combined(with: .opacity)
        ))
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        if Calendar.current.isDateInToday(date) {
            formatter.timeStyle = .short
            return "Today, \(formatter.string(from: date))"
        } else if Calendar.current.isDateInTomorrow(date) {
            formatter.timeStyle = .short
            return "Tomorrow, \(formatter.string(from: date))"
        } else {
            formatter.dateStyle = .short
            formatter.timeStyle = .short
            return formatter.string(from: date)
        }
    }
}

struct EmptyStateView: View {
    let hasFilters: Bool
    
    init(hasFilters: Bool = false) {
        self.hasFilters = hasFilters
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: hasFilters ? "magnifyingglass" : "checklist")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text(hasFilters ? "No Matching Todos" : "No Todos Yet")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text(hasFilters ? "Try adjusting your filters" : "Tap the + button to add your first todo")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Search todos...", text: $text)
                .textFieldStyle(.plain)
            
            if !text.isEmpty {
                Button(action: {
                    text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}

struct FilterChip: View {
    let title: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.caption)
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(Color(.systemGray5))
        .foregroundColor(.primary)
        .cornerRadius(16)
    }
}

struct FilterView: View {
    @ObservedObject var viewModel: TodoViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker("Category", selection: $viewModel.selectedCategory) {
                        ForEach(viewModel.allCategories, id: \.self) { category in
                            Text(category).tag(category)
                        }
                    }
                } header: {
                    Text("Category")
                }
                
                Section {
                    Picker("Priority", selection: Binding(
                        get: { viewModel.filterPriority ?? .medium },
                        set: { viewModel.filterPriority = $0 }
                    )) {
                        Text("All").tag(nil as Priority?)
                        ForEach(Priority.allCases, id: \.self) { priority in
                            HStack {
                                Image(systemName: priority.icon)
                                Text(priority.rawValue)
                            }
                            .tag(priority as Priority?)
                        }
                    }
                } header: {
                    Text("Priority")
                }
                
                Section {
                    Toggle("Show Completed", isOn: $viewModel.showCompleted)
                } header: {
                    Text("Display Options")
                }
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
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

struct TodoListView_Previews: PreviewProvider {
    static var previews: some View {
        TodoListView(viewModel: TodoViewModel())
    }
}

