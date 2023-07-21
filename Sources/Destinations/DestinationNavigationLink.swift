//
//  DestinationNavigationLink.swift
//  
//
//  Created by Mikhail Apurin on 22.07.2023.
//

import SwiftUI

public struct DestinationNavigationLink<Label: View, Destination: ResolvableDestination>: View {
    let link: NavigationLink<Label, DestinationResolvingView<Destination>>
    
    public init(destination: Destination.Type, configuration: Destination.Configuration, @ViewBuilder label: () -> Label) {
        self.link = NavigationLink {
            DestinationResolvingView<Destination>(configuration)
        } label: {
            label()
        }
    }
    
    public var body: some View {
        link
    }
}

extension DestinationNavigationLink where Label == Text {
    public init(_ titleKey: LocalizedStringKey, destination: Destination.Type, configuration: Destination.Configuration) {
        self.link = .init(titleKey) {
            DestinationResolvingView<Destination>(configuration)
        }
    }
    
    public init(_ title: some StringProtocol, destination: Destination.Type, configuration: Destination.Configuration) {
        self.link = .init(title) {
            DestinationResolvingView<Destination>(configuration)
        }
    }
}

extension DestinationNavigationLink {
    public init<Value: Hashable>(value: Value, @ViewBuilder label: () -> Label) where Destination == ValueDestination<Value> {
        self.link = .init {
            DestinationResolvingView<ValueDestination<Value>>(value)
        } label: {
            label()
        }
    }
}


extension DestinationNavigationLink where Label == Text {
    public init<Value: Hashable>(_ titleKey: LocalizedStringKey, value: Value) where Destination == ValueDestination<Value> {
        self.link = .init(titleKey) {
            DestinationResolvingView<ValueDestination<Value>>(value)
        }
    }
    
    public init<Value: Hashable>(_ title: some StringProtocol, value: Value) where Destination == ValueDestination<Value> {
        self.link = .init(title) {
            DestinationResolvingView<ValueDestination<Value>>(value)
        }
    }
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
struct DestinationNavigationLink_Previews: PreviewProvider {
    private struct TestDestination: ResolvableDestination {
        func body(configuration: String) -> some View {
            Text(configuration)
        }
    }
    
    static var previews: some View {
        NavigationStack {
            List {
                DestinationNavigationLink("Protocol link 1", destination: TestDestination.self, configuration: "Protocol conf 1")
                
                DestinationNavigationLink(destination: TestDestination.self, configuration: "Protocol conf 2") {
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
