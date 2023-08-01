//
//  DestinationNavigationLink.swift
//  
//
//  Created by Mikhail Apurin on 22.07.2023.
//

import SwiftUI

public struct DestinationNavigationLink<Label: View, Value: Hashable>: View {
    let value: Value
    
    let label: Label
    
    @Environment(\.destinationResolver) private var destinationResolver
    
    public init(value: Value, @ViewBuilder label: () -> Label) {
        self.value = value
        self.label = label()
    }
    
    public var body: some View {
        NavigationLink {
            DestinationView(value: value)
                .environment(\.destinationResolver, destinationResolver)
        } label: {
            label
        }
    }
}

extension DestinationNavigationLink where Label == Text {
    public init(_ titleKey: LocalizedStringKey, value: Value) {
        self.init(value: value) {
            Text(titleKey)
        }
    }
    
    public init(_ title: some StringProtocol, value: Value) {
        self.init(value: value) {
            Text(title)
        }
    }
}

struct DestinationNavigationLink_Previews: PreviewProvider {
    private struct TestDestination: ResolvableDestination {
        struct Value: Hashable {
            let text: String
        }

        func body(value: Value) -> some View {
            Text(value.text)
        }
    }
    
    static var previews: some View {
        navigation {
            List {
                Section("String") {
                    DestinationNavigationLink("Value 1", value: "Value 1")

                    DestinationNavigationLink(value: "Value 2") {
                        Text("Value 2")
                    }
                }

                Section("TestDestination.Value") {
                    DestinationNavigationLink("Value 1", value: TestDestination.Value(text: "Value 1"))
                    
                    DestinationNavigationLink(value: TestDestination.Value(text: "Value 2")) {
                        Text("Value 2")
                    }
                }
            }
            .headerProminence(.increased)
        }
        .destination(TestDestination())
        .destination(for: String.self) { Text($0) }
    }

    @ViewBuilder private static func navigation(@ViewBuilder root: () -> some View) -> some View {
        if #available(iOS 16.0, *) {
            NavigationStack {
                root().navigationTitle("NavigationStack")
            }
        } else {
            NavigationView {
                root().navigationTitle("NavigationView")
            }
        }
    }
}
