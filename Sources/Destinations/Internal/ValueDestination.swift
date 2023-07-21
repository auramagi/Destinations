//
//  ValueDestination.swift
//  
//
//  Created by Mikhail Apurin on 22.07.2023.
//

import SwiftUI

public struct ValueDestination<Value: Hashable>: ResolvableDestination {
    var destination: (Value) -> AnyView
    
    init<V: View>(@ViewBuilder _ destination: @escaping (Value) -> V) {
        self.destination = { AnyView(destination($0)) }
    }
    
    public func body(value: Value) -> some View {
        destination(value)
    }
}
