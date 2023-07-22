//
//  DestinationResolverInjectionModifier.swift
//  
//
//  Created by Mikhail Apurin on 22.07.2023.
//

import SwiftUI

struct DestinationResolverInjectionModifier: ViewModifier {
    @Environment(\.destinationResolver) private var environmentResolver
    
    @State private var resolver: DestinationResolver?

    func body(content: Content) -> some View {
        content
            .environment(\.destinationResolver, environmentResolver ?? resolver)
            .onAppear {
                updateState()
            }
            .onChange(of: environmentResolver?.id) { _ in
                updateState()
            }
    }
    
    func updateState() {
        if environmentResolver == nil {
            resolver = .init()
        } else {
            resolver = nil
        }
    }
}
