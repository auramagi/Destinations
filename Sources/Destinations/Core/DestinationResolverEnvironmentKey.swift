//
//  DestinationResolverEnvironmentKey.swift
//  
//
//  Created by Mikhail Apurin on 22.07.2023.
//

import SwiftUI

/// A key to hold a ``DestinationResolver`` in the SwiftUI environment.
public struct DestinationResolverEnvironmentKey: EnvironmentKey {
    public static var defaultValue: DestinationResolver? { nil }
}

extension EnvironmentValues {
    /// Current ``DestinationResolver``.
    /// A value is automatically injected when you provide a destination with either ``DestinationView/destination(_:)`` or ``DestinationView/destination(for:_:)``.
    /// Alternatively, ``DestinationView/withDestinationResolver()`` can be used to manually inject a fresh resolver that does not inherit destination from its environment.
    public var destinationResolver: DestinationResolver? {
        get { self[DestinationResolverEnvironmentKey.self] }
        set { self[DestinationResolverEnvironmentKey.self] = newValue }
    }
}
