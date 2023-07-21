//
//  ResolvableDestination.swift
//  
//
//  Created by Mikhail Apurin on 22.07.2023.
//

import SwiftUI

public protocol ResolvableDestination: DynamicProperty {
    associatedtype Configuration: Hashable

    associatedtype Content: View

    @ViewBuilder func body(configuration: Configuration) -> Content
}

extension ResolvableDestination {
    public static func resolve(_ configuration: Configuration) -> some View {
        DestinationResolvingView<Self>(configuration)
    }
}

extension View {
    public func destination<Destination: ResolvableDestination>(
        _ destination: @autoclosure @escaping () -> Destination
    ) -> some View {
        self
            .transformEnvironment(\.destinationResolver) { resolver in
                resolver?.register(provider: .init(make: destination))
            }
            .transformEnvironment(\.destinationResolver) { resolver in
                if resolver == nil {
                    resolver = .init()
                }
            }
    }
}
