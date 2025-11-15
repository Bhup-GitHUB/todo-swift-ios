# Todo App - iOS (Swift)

A simple and elegant todo app built with SwiftUI for iOS.

## Phase 1: Basic UI & Core Functionality ✅

This phase includes:

- ✅ List view of todos
- ✅ Add new todos
- ✅ Mark todos as complete/incomplete
- ✅ Delete todos
- ✅ Clean SwiftUI interface
- ✅ MVVM architecture

## Setup Instructions

### Prerequisites

- macOS with Xcode 14.0 or later
- iOS 15.0+ deployment target

### Steps to Run

1. **Open Xcode**

   - Launch Xcode on your MacBook

2. **Create New Project**

   - File → New → Project
   - Choose "iOS" → "App"
   - Product Name: `TodoApp`
   - Interface: `SwiftUI`
   - Language: `Swift`
   - Click "Next" and choose a location

3. **Replace Default Files**

   - Delete the default `ContentView.swift` that Xcode creates
   - Copy all files from this repository into your Xcode project:
     - `TodoApp/Models/TodoItem.swift`
     - `TodoApp/ViewModels/TodoViewModel.swift`
     - `TodoApp/Views/ContentView.swift`
     - `TodoApp/Views/TodoListView.swift`
     - `TodoApp/Views/AddTodoView.swift`
     - `TodoApp/TodoAppApp.swift`

4. **Update App Entry Point**

   - Make sure `TodoAppApp.swift` is set as the main entry point
   - The `@main` attribute should be on `TodoAppApp`

5. **Build and Run**
   - Select a simulator (iPhone 14 or later recommended)
   - Press `Cmd + R` to build and run

## Project Structure

```
TodoApp/
├── Models/
│   └── TodoItem.swift          # Todo data model
├── Views/
│   ├── ContentView.swift       # Main entry view
│   ├── TodoListView.swift      # List of todos
│   └── AddTodoView.swift       # Add new todo form
├── ViewModels/
│   └── TodoViewModel.swift     # Business logic & state management
└── TodoAppApp.swift            # App entry point
```

## Features

### Current Features (Phase 1)

- **View Todos**: See all your todos in a clean list
- **Add Todos**: Tap the + button to add new todos
- **Complete Todos**: Tap the circle icon to mark as complete/incomplete
- **Delete Todos**: Swipe left on a todo to delete it
- **Empty State**: Beautiful empty state when no todos exist

## Architecture

The app follows **MVVM (Model-View-ViewModel)** architecture:

- **Model**: `TodoItem` - Represents a single todo item
- **View**: SwiftUI views (`TodoListView`, `AddTodoView`, etc.)
- **ViewModel**: `TodoViewModel` - Manages todo state and business logic

## Next Steps (Phase 2)

- Data persistence (Core Data)
- Edit existing todos
- Categories/tags
- Search and filter
- Due dates
- Priority levels

## License

This project is open source and available for personal use.
