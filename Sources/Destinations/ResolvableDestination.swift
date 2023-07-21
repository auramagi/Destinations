//
//  ResolvableDestination.swift
//  
//
//  Created by Mikhail Apurin on 22.07.2023.
//

import SwiftUI

public protocol ResolvableDestination: DynamicProperty {
    associatedtype Value: Hashable

    associatedtype Content: View

    @ViewBuilder func body(value: Value) -> Content
}

extension ResolvableDestination {
    public static func resolve(_ value: Value) -> some View {
        DestinationResolvingView<Self>(value)
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
