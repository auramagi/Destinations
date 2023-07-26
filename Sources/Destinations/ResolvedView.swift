//
//  ResolvedView.swift
//  
//
//  Created by Mikhail Apurin on 22.07.2023.
//

import SwiftUI

public struct ResolvedView<Destination: ResolvableDestination, Value: Hashable>: View {
    enum Content {
        case destinationValue(Destination.Value)
        case anyValue(Value)
    }

    let content: Content

    public var body: some View {
        switch content {
        case let .destinationValue(value):
            DestinationResolvingView<Destination>(value)

        case let .anyValue(value):
            DestinationResolvingView<ValueDestination>(value)
        }
    }
}

extension ResolvedView where Value == Destination.Value {
    public init(destination: Destination.Type, value: Value) {
        self.content = .destinationValue(value)
    }
}

extension Never: ResolvableDestination {
    public func body(value: Never) -> EmptyView { }
}

extension ResolvedView where Destination == Never {
    public init(value: Value) {
        self.content = .anyValue(value)
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
