//
//  DestinationNavigationLink.swift
//  
//
//  Created by Mikhail Apurin on 22.07.2023.
//

import SwiftUI

public struct DestinationNavigationLink<Label: View, Destination: ResolvableDestination>: View {
    let value: Destination.Value
    
    let label: Label
    
    @Environment(\.destinationResolver) private var destinationResolver
    
    public init(destination: Destination.Type, value: Destination.Value, @ViewBuilder label: () -> Label) {
        self.value = value
        self.label = label()
    }
    
    public var body: some View {
        NavigationLink {
            DestinationView(Destination.self, value: value)
                .environment(\.destinationResolver, destinationResolver)
        } label: {
            label
        }
    }
}

extension DestinationNavigationLink where Label == Text {
    public init(_ titleKey: LocalizedStringKey, destination: Destination.Type, value: Destination.Value) {
        self.init(destination: destination, value: value) {
            Text(titleKey)
        }
    }
    
    public init(_ title: some StringProtocol, destination: Destination.Type, value: Destination.Value) {
        self.init(destination: destination, value: value) {
            Text(title)
        }
    }
}

extension DestinationNavigationLink {
    public init<Value: Hashable>(value: Value, @ViewBuilder label: () -> Label) where Destination == ValueDestination<Value> {
        self.init(destination: ValueDestination<Value>.self, value: value, label: label)
    }
}

extension DestinationNavigationLink where Label == Text {
    public init<Value: Hashable>(_ titleKey: LocalizedStringKey, value: Value) where Destination == ValueDestination<Value> {
        self.init(destination: ValueDestination<Value>.self, value: value) {
            Text(titleKey)
        }
    }
    
    public init<Value: Hashable>(_ title: some StringProtocol, value: Value) where Destination == ValueDestination<Value> {
        self.init(destination: ValueDestination<Value>.self, value: value) {
            Text(title)
        }
    }
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
struct DestinationNavigationLink_Previews: PreviewProvider {
    private struct TestDestination: ResolvableDestination {
        func body(value: String) -> some View {
            Text(value)
        }
    }
    
    static var previews: some View {
        NavigationStack {
            List {
                DestinationNavigationLink("Protocol link 1", destination: TestDestination.self, value: "Protocol value 1")
                
                DestinationNavigationLink(destination: TestDestination.self, value: "Protocol value 2") {
                    Text("Protocol link 2")
                }
                
                DestinationNavigationLink("Value link 1", value: "Value 1")
                
                DestinationNavigationLink(value: "Value 2") {
                    Text("Value link 2")
                }
            }
        }
        .destination(TestDestination())
        .destination(for: String.self) { Text($0) }
    }
}
