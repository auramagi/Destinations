//
//  DestinationView.swift
//  
//
//  Created by Mikhail Apurin on 22.07.2023.
//

import SwiftUI

/// Abstract view that will be dynamically resolved to the view associated with its ``ResolvableDestination``.
public struct DestinationView<Destination: ResolvableDestination>: View {
    let value: Destination.Value

    @Environment(\.destinationResolver) private var resolver

    @State private var updatedDestination: Destination?

    public var body: some View {
        Group {
            if let resolver, let destination = updatedDestination ?? resolver.provider(for: Destination.self)?.make() {
                ResolvedDestinationView(
                    destination: destination,
                    value: value
                )
            } else {
                Image(systemName: "exclamationmark.triangle")
                    .symbolVariant(.fill)
                    .symbolRenderingMode(.multicolor)
            }
        }
        .task(id: resolver?.id) {
            guard let resolver else { return }
            let values = resolver.providerUpdates(for: Destination.self).eraseToAnyPublisher().values
            for await provider in values {
                updatedDestination = provider.make()
            }
            updatedDestination = nil
        }
    }
}

extension DestinationView {
    /// Create a destination for a custom ``ResolvableDestination`` type.
    /// - Parameters:
    ///   - destination: Custom resolvable destination type
    ///   - value:  ``ResolvableDestination/Value`` data associated with the custom resolvable destination type
    public init(_ destination: Destination.Type = Destination.self, value: Destination.Value) {
        self.value = value
    }
}

extension DestinationView {
    /// Create a destination for any value type that conforms to `Hashable`.
    /// - Parameter value: Value data to provide to the matching ``DestinationView/destination(_:)``
    public init<Value: Hashable>(value: Value) where Destination == ValueDestination<Value> {
        self.init(ValueDestination<Value>.self, value: value)
    }
}
