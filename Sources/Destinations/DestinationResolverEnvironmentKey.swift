//
//  DestinationResolverEnvironmentKey.swift
//  
//
//  Created by Mikhail Apurin on 22.07.2023.
//

import SwiftUI

public struct DestinationResolverEnvironmentKey: EnvironmentKey {
    public static var defaultValue: DestinationResolver? { nil }
}

extension EnvironmentValues {
    public var destinationResolver: DestinationResolver? {
        get { self[DestinationResolverEnvironmentKey.self] }
        set { self[DestinationResolverEnvironmentKey.self] = newValue }
    }
}
