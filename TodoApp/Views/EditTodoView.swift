import SwiftUI

struct EditTodoView: View {
    @ObservedObject var viewModel: TodoViewModel
    @Environment(\.dismiss) var dismiss
    
    let todo: TodoItem
    
    @State private var todoTitle: String
    @State private var category: String
    @State private var dueDate: Date?
    @State private var hasDueDate: Bool
    @State private var priority: Priority
    @State private var notes: String
    @State private var isCompleted: Bool
    @FocusState private var isTextFieldFocused: Bool
    
    init(viewModel: TodoViewModel, todo: TodoItem) {
        self.viewModel = viewModel
        self.todo = todo
        _todoTitle = State(initialValue: todo.title)
        _category = State(initialValue: todo.category)
        _dueDate = State(initialValue: todo.dueDate)
        _hasDueDate = State(initialValue: todo.dueDate != nil)
        _priority = State(initialValue: todo.priority)
        _notes = State(initialValue: todo.notes)
        _isCompleted = State(initialValue: todo.isCompleted)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Enter todo title", text: $todoTitle)
                        .focused($isTextFieldFocused)
                    
                    Toggle("Completed", isOn: $isCompleted)
                } header: {
                    Text("Title")
                }
                
                Section {
                    Picker("Category", selection: $category) {
                        ForEach(viewModel.allCategories.filter { $0 != "All" }, id: \.self) { cat in
                            Text(cat).tag(cat)
                        }
                    }
                    
                    TextField("New category", text: Binding(
                        get: { category },
                        set: { newValue in
                            category = newValue
                        }
                    ))
                } header: {
                    Text("Category")
                }
                
                Section {
                    Picker("Priority", selection: $priority) {
                        ForEach(Priority.allCases, id: \.self) { pri in
                            HStack {
                                Image(systemName: pri.icon)
                                Text(pri.rawValue)
                            }
                            .tag(pri)
                        }
                    }
                    
                    Toggle("Set Due Date", isOn: $hasDueDate)
                    
                    if hasDueDate {
                        DatePicker("Due Date", selection: Binding(
                            get: { dueDate ?? Date() },
                            set: { dueDate = $0 }
                        ), displayedComponents: [.date, .hourAndMinute])
                    }
                } header: {
                    Text("Details")
                }
                
                Section {
                    TextEditor(text: $notes)
                        .frame(minHeight: 100)
                } header: {
                    Text("Notes (Optional)")
                }
            }
            .navigationTitle("Edit Todo")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveTodo()
                    }
                    .disabled(todoTitle.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
            .onAppear {
                isTextFieldFocused = true
            }
        }
    }
    
    private func saveTodo() {
        var updatedTodo = todo
        updatedTodo.title = todoTitle
        updatedTodo.category = category.isEmpty ? "General" : category
        updatedTodo.dueDate = hasDueDate ? dueDate : nil
        updatedTodo.priority = priority
        updatedTodo.notes = notes
        updatedTodo.isCompleted = isCompleted
        
        viewModel.updateTodo(updatedTodo)
        dismiss()
    }
}

struct EditTodoView_Previews: PreviewProvider {
    static var previews: some View {
        EditTodoView(
            viewModel: TodoViewModel(),
            todo: TodoItem(title: "Sample Todo", category: "Work", priority: .high)
        )
    }
}

