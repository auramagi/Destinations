# Destinations

Resolve SwiftUI views trough a resolver injected in parent. Modeled after NavigationStack navigationDestination pattern.

## Usage

### Destinations with the `ResolvableDestination` protocol

1. Implement a custom type that adopts the `ResolvableDestination` protocol
2. Provide a value of this type in the parent view with the `destination` view modifier
3. Resolve the view using `DestinationView` with the initializer that takes the destination type as the first argument

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
        DestinationView(MyDestination.self, value: 1)
    }
}
```

### Destinations with `@ViewBuilder` closures

Destinations comes with one special destination that you can use to resolve any Hashable value without implementing a custom `ResolvableDestination` type.

1. Provide a `@ViewBuilder` closure for a value type in the parent view with the `destination(for:)` view modifier
2. Resolve the view using `DestinationView` with the initializer with the value as the only argument

Note, however, that while this approach more closely resembles NavigationStack and is easier to use, it has one significant one significant trade-off. Like NavigationStack, it uses `AnyView` inside to erase the type information of the view that you provide in the `destination` closure, which is an unavoidable syntax limitation. In practical terms, this is may be less efficient when SwiftUI needs to detect changes between view updates.

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
                    destination: MyDestination.self,
                    value: "Hello, world!"
                )
                
                Button("Present MyDestination modally") {
                    isSheetPresented.toggle()
                }
            }
        }
        .sheet(
            isPresented: $isSheetPresented,
            destination: MyDestination.self,
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

