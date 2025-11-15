import SwiftUI

struct TodoListView: View {
    @ObservedObject var viewModel: TodoViewModel
    @State private var showingAddTodo = false
    
    var body: some View {
        NavigationView {
            ZStack {
                if viewModel.todos.isEmpty {
                    EmptyStateView()
                } else {
                    List {
                        ForEach(viewModel.todos) { todo in
                            TodoRowView(todo: todo) {
                                viewModel.toggleTodo(todo)
                            }
                        }
                        .onDelete { indexSet in
                            viewModel.deleteTodo(at: indexSet)
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("My Todos")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddTodo = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $showingAddTodo) {
                AddTodoView(viewModel: viewModel)
            }
        }
    }
}

struct TodoRowView: View {
    let todo: TodoItem
    let onToggle: () -> Void
    
    var body: some View {
        HStack {
            Button(action: onToggle) {
                Image(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(todo.isCompleted ? .green : .gray)
                    .font(.title2)
            }
            .buttonStyle(.plain)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(todo.title)
                    .font(.body)
                    .strikethrough(todo.isCompleted)
                    .foregroundColor(todo.isCompleted ? .secondary : .primary)
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "checklist")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("No Todos Yet")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Tap the + button to add your first todo")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

struct TodoListView_Previews: PreviewProvider {
    static var previews: some View {
        TodoListView(viewModel: TodoViewModel())
    }
}

