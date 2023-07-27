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

    func register<D: ResolvableDestination>(provider: ResolvableDestinationProvider<D>) {
        providers[ObjectIdentifier(D.self)] = provider
        onChange.send(provider)
    }

    func provider<D: ResolvableDestination>(for destinationType: D.Type) -> ResolvableDestinationProvider<D>? {
        providers[ObjectIdentifier(D.self)] as? ResolvableDestinationProvider<D>
    }

    func providerUpdates<D: ResolvableDestination>(for destinationType: D.Type) -> any Publisher<ResolvableDestinationProvider<D>, Never> {
        onChange.compactMap { $0 as? ResolvableDestinationProvider<D> }
    }
}

extension DestinationResolver {
    /// Check whether this object can resolve a custom ``ResolvableDestination`` type.
    /// - Parameter destinationType: Custom resolvable destination type
    public func canResolve<Destination: ResolvableDestination>(destinationType: Destination.Type) -> Bool {
        provider(for: destinationType) != nil
    }

    /// Check whether this object can resolve a value type.
    /// - Parameter valueType: A resolvable value type.
    public func canResolve<Value: Hashable>(valueType: Value.Type) -> Bool {
        canResolve(destinationType: ValueDestination<Value>.self)
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


