# Book Radar

**Book Radar** is a personal library management app built with SwiftUI. Discover new books using the Google Books API, track your reading progress, and organize your collection with custom reading lists. The app uses a modular architecture with a separate Swift Package for API integration, Core Data for offline storage, and a hybrid of SwiftUI and UIKit components for optimal performance.

## Features

- **Book discovery** via Google Books API search
- **Personal library management** with custom reading lists
- **Reading progress tracking** with planned calendar visualization
- **Wishlist functionality** for books you want to read
- **Hybrid UI approach** combining SwiftUI with UIKit Collection Views
- **Offline storage** with Core Data persistence

## Technologies

- **Swift, SwiftUI**
- **UIKit** (Collection View components)
- **Core Data** for local persistence
- **Google Books API** integration via `BookAPIKit`
- **Swift Package Manager** (custom `BookAPIKit` package)
- **MVVM architecture pattern**

## Architecture

Book Radar is built with a modular architecture and clear separation of concerns:

- **BookAPIKit**: Custom Swift Package providing a Google Books API layer (maintained as a separate repository)
- **SwiftUI**: Main interface and navigation
- **UIKit Collection Views**: Embedded in SwiftUI for optimized book grid displays
- **Core Data**: Local book storage and reading lists
- **MVVM pattern**: Throughout the application for scalable code structure
