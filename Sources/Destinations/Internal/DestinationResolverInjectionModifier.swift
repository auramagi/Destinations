//
//  DestinationResolverInjectionModifier.swift
//  
//
//  Created by Mikhail Apurin on 22.07.2023.
//

import SwiftUI

struct DestinationResolverInjectionModifier: ViewModifier {
    let prefersEnvironmentResolver: Bool

    @State private var resolver = DestinationResolver()

    @Environment(\.destinationResolver) private var environmentResolver

    func body(content: Content) -> some View {
        content
            .environment(\.destinationResolver, injectedResolver)
    }

    var injectedResolver: DestinationResolver {
        if prefersEnvironmentResolver, let environmentResolver {
            return environmentResolver
        } else {
            return resolver
        }
    }
}
