# Todo App - iOS (Swift)

A simple and elegant todo app built with SwiftUI for iOS.

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
     - `TodoApp/Views/EditTodoView.swift`
     - `TodoApp/Services/DataManager.swift`
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
│   └── TodoItem.swift          # Todo data model with priority, category, due date
├── Views/
│   ├── ContentView.swift       # Main entry view
│   ├── TodoListView.swift      # List of todos with search & filters
│   ├── AddTodoView.swift       # Add new todo form
│   └── EditTodoView.swift      # Edit existing todo form
├── ViewModels/
│   └── TodoViewModel.swift     # Business logic & state management
├── Services/
│   └── DataManager.swift      # UserDefaults persistence layer
└── TodoAppApp.swift            # App entry point
```

## Features

### Current Features

- **View Todos**: See all your todos in a clean list with priority indicators
- **Add Todos**: Tap the + button to add new todos with category, priority, due date, and notes
- **Edit Todos**: Tap on any todo to edit its details
- **Complete Todos**: Tap the circle icon to mark as complete/incomplete
- **Delete Todos**: Swipe left on a todo to delete it
- **Search**: Search todos by title, category, or notes
- **Filter**: Filter by category, priority, or completion status
- **Categories**: Organize todos with custom categories
- **Priority Levels**: Set Low, Medium, or High priority with visual indicators
- **Due Dates**: Set due dates with overdue detection (red color for overdue)
- **Notes**: Add additional notes to todos
- **Data Persistence**: All todos are automatically saved using UserDefaults
- **Empty State**: Beautiful empty state when no todos exist

## Architecture

The app follows **MVVM (Model-View-ViewModel)** architecture:

- **Model**: `TodoItem` - Represents a single todo item
- **View**: SwiftUI views (`TodoListView`, `AddTodoView`, etc.)
- **ViewModel**: `TodoViewModel` - Manages todo state and business logic

## Next Steps (Phase 3)

- Animations and transitions
- Dark mode support
- Notifications/reminders
- Statistics/analytics (completed tasks, streaks)
- Swipe gestures for quick actions
- Widget support (iOS 14+)
- iCloud sync (optional)
- Export/share functionality

## License

This project is open source and available for personal use.
