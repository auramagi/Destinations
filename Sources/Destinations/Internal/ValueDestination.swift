//
//  ValueDestination.swift
//  
//
//  Created by Mikhail Apurin on 22.07.2023.
//

import SwiftUI

struct ValueDestination<Value: Hashable>: ResolvableDestination {
    typealias Configuration = Value
    
    var destination: (Value) -> AnyView
    
    init<V: View>(@ViewBuilder _ destination: @escaping (Value) -> V) {
        print(#function)
        self.destination = { AnyView(destination($0)) }
    }
    
    func body(configuration: Value) -> some View {
        let _ = print(#function)
        destination(configuration)
    }
}
