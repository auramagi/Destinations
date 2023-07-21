//
//  ResolvedDestinationView.swift
//  
//
//  Created by Mikhail Apurin on 22.07.2023.
//

import SwiftUI

struct ResolvedDestinationView<D: ResolvableDestination>: View {
    let destination: D
    
    let configuration: D.Configuration
    
    var body: some View {
        destination.body(configuration: configuration)
    }
}
