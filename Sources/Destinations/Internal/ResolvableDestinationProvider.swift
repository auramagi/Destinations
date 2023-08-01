//
//  ResolvableDestinationProvider.swift
//  
//
//  Created by Mikhail Apurin on 22.07.2023.
//

import SwiftUI

struct ResolvableDestinationProvider<Value: Hashable> {
    let make: (Value) -> AnyView
}
