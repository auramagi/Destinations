//
//  DestinationResolvingView.swift
//  
//
//  Created by Mikhail Apurin on 22.07.2023.
//

import SwiftUI

struct DestinationResolvingView<D: ResolvableDestination>: View {
    let configuration: D.Configuration

    @Environment(\.destinationResolver) private var resolver

    @State private var destination: D?

    init(_ configuration: D.Configuration) {
        self.configuration = configuration
    }

    var body: some View {
        Group {
            if let destination {
                ResolvedDestinationView(
                    destination: destination,
                    configuration: configuration
                )
            } else {
                Image(systemName: "exclamationmark.triangle")
                    .symbolVariant(.fill)
                    .symbolRenderingMode(.multicolor)
            }
        }
        .task(id: resolver?.id) {
            guard let resolver else { return }
            destination = resolver.provider(for: D.self)?.make()
            let values = resolver.providerUpdates(for: D.self).eraseToAnyPublisher().values
            for await provider in values {
                self.destination = provider.make()
            }
        }
    }
}
