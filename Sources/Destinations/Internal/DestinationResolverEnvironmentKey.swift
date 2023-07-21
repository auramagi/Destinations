//
//  DestinationResolverEnvironmentKey.swift
//  
//
//  Created by Mikhail Apurin on 22.07.2023.
//

import SwiftUI

struct DestinationResolverEnvironmentKey: EnvironmentKey {
    static var defaultValue: DestinationResolver? { nil }
}

extension EnvironmentValues {
    var destinationResolver: DestinationResolver? {
        get { self[DestinationResolverEnvironmentKey.self] }
        set { self[DestinationResolverEnvironmentKey.self] = newValue }
    }
}
