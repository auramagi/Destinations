//
//  DestinationView.swift
//  
//
//  Created by Mikhail Apurin on 22.07.2023.
//

import SwiftUI

/// Abstract view that will be dynamically resolved to the view associated with its ``ResolvableDestination``.
public struct DestinationView<Value: Hashable>: View {
    let value: Value

    @Environment(\.destinationResolver) private var resolver

    @State private var updatedProvider: ResolvableDestinationProvider<Value>?

    /// Resolve and display a destination view for a data value that conforms to `Hashable`.
    /// - Parameter value: Value data to provide to the matching ``DestinationView/destination(_:)``
    public init(value: Value) {
        self.value = value
    }

    public var body: some View {
        Group {
            if let resolver, let provider = updatedProvider ?? resolver.provider(for: Value.self) {
                provider(value)
            } else {
                Image(systemName: "exclamationmark.triangle")
                    .symbolVariant(.fill)
                    .symbolRenderingMode(.multicolor)
            }
        }
        .task(id: resolver?.id) {
            guard let resolver else { return }
            let values = resolver.providerUpdates(for: Value.self).eraseToAnyPublisher().values
            for await provider in values {
                updatedProvider = provider
            }
            updatedProvider = nil
        }
    }
}
