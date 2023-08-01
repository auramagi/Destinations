# Destinations

Resolve SwiftUI views trough a resolver injected in parent that is inspired by NavigationStack navigationDestination pattern.

## Usage

### Destinations with `@ViewBuilder` closures

This is the most basic way to use Destinations.

1. Register a `@ViewBuilder` closure for a value type with the `destination(for:)` view modifier
2. In a child view, resolve the destination by using `DestinationView` with a matching value type 

```swift
import Destinations

struct ParentView: View {
    var body: some View {
        ChildView()
            .destination(for: Int.self) { value in
                Text(100 + value, format: .number)
            }
    }
}

struct ChildView: View {
    var body: some View {
        DestinationView(value: 1)
    }
}
```

### Destinations with the `ResolvableDestination` protocol

Alternatively, you can register a custom `ResolvableDestination` implementation. This way you can inject properties from the parent and hold some state with SwiftUI property wrappers.

1. Implement a custom type that adopts the `ResolvableDestination` protocol
2. Register a value of this type with the `destination(_:)` view modifier
3. In a child view, resolve the view by using `DestinationView` with a value type that matches the value type used in step 1 

```swift
import Destinations

struct MyDestination: ResolvableDestination {
    let base: Int
    
    func body(value: Int) -> some View {
        Text(base + value, format: .number)
    }
}

struct ParentView: View {
    var body: some View {
        ChildView()
            .destination(MyDestination(base: 100))
    }
}

struct ChildView: View {
    var body: some View {
        DestinationView(value: 1)
    }
}
```

## Advanced Usage

### Use in navigation

The resolver pattern matches very well with uses in navigation. Destinations comes with support for custom navigation links and sheets.

```swift
struct MyDestination: ResolvableDestination {
    func body(value: String) -> some View {
        Text(value)
    }
}

struct ContentView: View {
    @State var isSheetPresented = false
    
    var body: some View {
        NavigationStack {
            List {
                DestinationNavigationLink(
                    "Present MyDestination with push transition",
                    value: "Hello, world!"
                )
                
                Button("Present MyDestination modally") {
                    isSheetPresented.toggle()
                }
            }
        }
        .sheet(
            isPresented: $isSheetPresented,
            value: "Hello, modal world!"
        )
        .destination(MyDestination())
    }
}
```

### Use SwiftUI state in your destination types

Since types that conform to `ResolvableDestination` also conform to `DynamicProperty`, you can use SwiftUI state property wrappers like `@Environment` and `@State` in your destination types.

```swift
struct FileSizeLabelDestination: ResolvableDestination {
    @State private var fileSize: Result<Int, Error>?
    
    let calculateFileSize: (URL) throws -> Int
    
    func body(value: URL) -> some View {
        Group {
            switch fileSize {
            case .none:
                ProgressView()
                
            case let .success(size):
                Text(
                    Measurement(value: Double(size), unit: UnitInformationStorage.bytes),
                    format: .byteCount(style: .file)
                )

            case let .failure(error):
                Text(error.localizedDescription)
            }
        }
        .task(id: value) {
            fileSize = .init { try calculateFileSize(value) }
        }
    }
}
```
