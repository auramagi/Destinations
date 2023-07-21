//
//  DestinationResolvingView.swift
//  
//
//  Created by Mikhail Apurin on 22.07.2023.
//

import SwiftUI

struct DestinationResolvingView<D: ResolvableDestination>: View {
    let value: D.Value

    @Environment(\.destinationResolver) private var resolver

    @State private var updatedDestination: D?

    init(_ value: D.Value) {
        self.value = value
    }

    var body: some View {
        Group {
            if let resolver, let destination = updatedDestination ?? resolver.provider(for: D.self)?.make() {
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
            let values = resolver.providerUpdates(for: D.self).eraseToAnyPublisher().values
            for await provider in values {
                self.updatedDestination = provider.make()
            }
        }
    }
}
