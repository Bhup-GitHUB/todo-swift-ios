import SwiftUI

struct AddTodoView: View {
    @ObservedObject var viewModel: TodoViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var todoTitle: String = ""
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Enter todo title", text: $todoTitle)
                        .focused($isTextFieldFocused)
                } header: {
                    Text("New Todo")
                }
            }
            .navigationTitle("Add Todo")
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
        viewModel.addTodo(title: todoTitle)
        dismiss()
    }
}

struct AddTodoView_Previews: PreviewProvider {
    static var previews: some View {
        AddTodoView(viewModel: TodoViewModel())
    }
}

