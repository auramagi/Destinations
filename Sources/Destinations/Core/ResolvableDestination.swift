//
//  ResolvableDestination.swift
//  
//
//  Created by Mikhail Apurin on 22.07.2023.
//

import SwiftUI

public protocol ResolvableDestination: DynamicProperty {
    /// Value data type associated with this destination.
    associatedtype Value: Hashable

    /// `View` type to which this destination resolves.
    associatedtype Content: View

    /// Resolve this destination for the provided ``Value`` data.
    /// - Parameter value: Data of the associated ``Value`` type
    /// - Returns: Resolved destination `View`
    @ViewBuilder func body(value: Value) -> Content
}

extension View {
    /// Associates a custom ``ResolvableDestination`` type to be later resolved through ``DestinationView``.
    /// - Parameter destination: The custom type that this destination matches
    public func destination<Destination: ResolvableDestination>(
        _ destination: @autoclosure @escaping () -> Destination
    ) -> some View {
        self
            .transformEnvironment(\.destinationResolver) { resolver in
                resolver?.register(destination: destination())
            }
            .modifier(DestinationResolverInjectionModifier(prefersEnvironmentResolver: true))
    }

    /// Associates a `@ViewBuilder` closure with the provided value data type to be later resolved through ``DestinationView``.
    /// - Parameters:
    ///   - valueType: The type of data that this destination matches
    ///   - destination: A view builder that defines a view to display when
    public func destination<Value: Hashable, Content: View>(
        for valueType: Value.Type,
        @ViewBuilder _ destination: @escaping (Value) -> Content
    ) -> some View {
        self.destination(ValueDestination(destination))
    }
}
