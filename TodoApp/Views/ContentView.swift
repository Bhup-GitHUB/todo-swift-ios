import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = TodoViewModel()
    
    var body: some View {
        TodoListView(viewModel: viewModel)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

