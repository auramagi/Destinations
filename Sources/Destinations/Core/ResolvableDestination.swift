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

extension View {
    public func destination<Destination: ResolvableDestination>(
        _ destination: @autoclosure @escaping () -> Destination
    ) -> some View {
        self
            .transformEnvironment(\.destinationResolver) { resolver in
                resolver?.register(provider: .init(make: destination))
            }
            .modifier(DestinationResolverInjectionModifier(prefersEnvironmentResolver: true))
    }

    public func destination<Value: Hashable, Content: View>(
        for valueType: Value.Type,
        @ViewBuilder _ destination: @escaping (Value) -> Content
    ) -> some View {
        self.destination(ValueDestination(destination))
    }
}
