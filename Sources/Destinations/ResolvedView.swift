//
//  ResolvedView.swift
//  
//
//  Created by Mikhail Apurin on 22.07.2023.
//

import SwiftUI

public struct ResolvedView<Value: Hashable>: View {
    let value: Value
    
    public init(value: Value) {
        self.value = value
    }
    
    public var body: some View {
        ValueDestination.resolve(value)
    }
}

extension View {
    public func destination<Value: Hashable, Content: View>(
        for valueType: Value.Type,
        @ViewBuilder _ destination: @escaping (Value) -> Content
    ) -> some View {
        self.destination(ValueDestination(destination))
    }
}
