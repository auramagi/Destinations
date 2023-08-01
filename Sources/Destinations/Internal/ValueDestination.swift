//
//  ValueDestination.swift
//  
//
//  Created by Mikhail Apurin on 22.07.2023.
//

import SwiftUI

/// A special destination type that is used to represent destinations that match a value data type provided through ``DestinationView/destination(for:_:)``.
struct ValueDestination<Value: Hashable>: ResolvableDestination {
    var destination: (Value) -> AnyView
    
    init<V: View>(@ViewBuilder _ destination: @escaping (Value) -> V) {
        self.destination = { AnyView(destination($0)) }
    }
    
    func body(value: Value) -> some View {
        destination(value)
    }
}
