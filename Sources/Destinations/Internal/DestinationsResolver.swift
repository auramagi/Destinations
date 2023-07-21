//
//  DestinationsResolver.swift
//  
//
//  Created by Mikhail Apurin on 22.07.2023.
//

import Combine
import SwiftUI

final class DestinationResolver: Identifiable {
    var id: ObjectIdentifier { .init(self) }
    
    private var providers: [ObjectIdentifier: Any] = [:]

    private let onChange = PassthroughSubject<Any, Never>()

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
