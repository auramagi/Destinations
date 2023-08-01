//
//  ResolvableDestinationProvider.swift
//  
//
//  Created by Mikhail Apurin on 22.07.2023.
//

import SwiftUI

struct ResolvableDestinationProvider<Value: Hashable> {
    private let closure: (Value) -> AnyView

    init<Destination: ResolvableDestination>(destination: @autoclosure @escaping () -> Destination) where Destination.Value == Value {
        self.closure = {
            // Wait, isn't AnyView evil?
            // When it is used to erase different return types for the view inside -- yes, absolutely. Doing this will mess with the
            // structural identity and result in views losing state, incessant transition animations, etc. But we're not doing this here.
            // Here, we're just erasing the actual view type so that the child that uses this destination doesn't need to know what the
            // parent provides. This keeps the identity of the view inside, since the actual type doesn't change. This may be somewhat
            // less performant for SwiftUI internal diffing, but no less so as, for example, storing closures as View properties.
            // In any case, this is exactly what Xcode Previews and some navigational modifiers do in SwiftUI already, including NavigationStack.
            AnyView(
                ResolvedDestinationView(destination: destination(), value: $0)
            )
        }
    }

    func callAsFunction(_ value: Value) -> AnyView {
        closure(value)
    }
}
