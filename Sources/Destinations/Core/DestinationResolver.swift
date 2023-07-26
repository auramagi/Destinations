//
//  DestinationResolver.swift
//  
//
//  Created by Mikhail Apurin on 22.07.2023.
//

import Combine
import SwiftUI

public final class DestinationResolver: Identifiable {
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
    public func canResolve<Destination: ResolvableDestination>(destinationType: Destination.Type) -> Bool {
        provider(for: destinationType) != nil
    }
    
    public func canResolve<Value: Hashable>(valueType: Value.Type) -> Bool {
        canResolve(destinationType: ValueDestination<Value>.self)
    }
}

extension View {
    public func withNavigationResolver() -> some View {
        self.modifier(DestinationResolverInjectionModifier(prefersEnvironmentResolver: false))
    }
}
