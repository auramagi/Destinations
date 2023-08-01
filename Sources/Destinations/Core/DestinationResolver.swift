//
//  DestinationResolver.swift
//  
//
//  Created by Mikhail Apurin on 22.07.2023.
//

import Combine
import SwiftUI

/// Object responsible for holding on to provided destinations and vending them to ``DestinationView``.
public final class DestinationResolver: Identifiable {
    /// This object's identity
    public var id: ObjectIdentifier { .init(self) }

    private var providers: [ObjectIdentifier: Any] = [:]

    private let onChange = PassthroughSubject<Any, Never>()
    
    public init() { }

    func register<Destination: ResolvableDestination>(destination: @autoclosure @escaping () -> Destination) {
        let provider = ResolvableDestinationProvider(make: { AnyView(ResolvedDestinationView(destination: destination(), value: $0)) })
        providers[ObjectIdentifier(Destination.Value.self)] = provider
        onChange.send(provider)
    }

    func provider<Value: Hashable>(for valueType: Value.Type) -> ResolvableDestinationProvider<Value>? {
        providers[ObjectIdentifier(Value.self)] as? ResolvableDestinationProvider<Value>
    }

    func providerUpdates<Value: Hashable>(for valueType: Value.Type) -> any Publisher<ResolvableDestinationProvider<Value>, Never> {
        onChange.compactMap { $0 as? ResolvableDestinationProvider<Value> }
    }
}

extension DestinationResolver {
    /// Check whether this object can resolve a value type.
    /// - Parameter valueType: A resolvable value type.
    public func canResolve<V: Hashable>(valueType: V.Type) -> Bool {
        provider(for: valueType) != nil
    }
}

extension View {
    /// Inject a fresh ``DestinationResolver`` into SwiftUI environment.
    /// - Note: If the environment does not contain a resolver, a new one will be created when you provide a destination with either ``DestinationView/destination(_:)`` or ``DestinationView/destination(for:_:)``.
    ///    Use this modifier when you explicitly want to create a new resolver that does not inherit any destinations from the environment.
    public func withDestinationResolver() -> some View {
        self.modifier(DestinationResolverInjectionModifier(prefersEnvironmentResolver: false))
    }
}


