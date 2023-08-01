//
//  ClosureDestination.swift
//  
//
//  Created by Mikhail Apurin on 22.07.2023.
//

import SwiftUI

/// A special destination type that is used to represent destinations that match a value data type provided through ``DestinationView/destination(for:_:)``.
struct ClosureDestination<Value: Hashable, Content: View>: ResolvableDestination {
    var destination: (Value) -> Content
    
    init(@ViewBuilder _ destination: @escaping (Value) -> Content) {
        self.destination = destination
    }
    
    func body(value: Value) -> some View {
        destination(value)
    }
}
