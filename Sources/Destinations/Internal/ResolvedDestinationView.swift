//
//  ResolvedDestinationView.swift
//  
//
//  Created by Mikhail Apurin on 22.07.2023.
//

import SwiftUI

struct ResolvedDestinationView<D: ResolvableDestination>: View {
    let destination: D
    
    let value: D.Value
    
    var body: some View {
        destination.body(value: value)
    }
}
