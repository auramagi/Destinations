//
//  View+Destinations.swift
//  
//
//  Created by Mikhail Apurin on 22.07.2023.
//

import SwiftUI

extension View {
    public func sheet<Value: Hashable>(
        isPresented: Binding<Bool>,
        onDismiss: (() -> Void)? = nil,
        value: Value
    ) -> some View {
        self.sheet(isPresented: isPresented, onDismiss: onDismiss) {
            DestinationView(value: value)
        }
    }

    public func sheet<Item: Identifiable, Value: Hashable>(
        item: Binding<Item?>,
        onDismiss: (() -> Void)? = nil,
        value: @escaping (Item) -> Value
    ) -> some View {
        self.sheet(item: item, onDismiss: onDismiss) { item in
            DestinationView(value: value(item))
        }
    }

    public func sheet<Value: Hashable>(
        value: Binding<Value?>,
        onDismiss: (() -> Void)? = nil
    ) -> some View where Value: Identifiable {
        self.sheet(item: value, onDismiss: onDismiss) { value in
            DestinationView(value: value)
        }
    }
}

struct Sheets_Previews: PreviewProvider {
    private struct TestItem: Identifiable, Hashable {
        let id: String
    }
    
    private struct TestDestination: ResolvableDestination {
        func body(value: TestItem) -> some View {
            Text(value.id)
        }
    }
    
    private struct Internal: View {
        @State private var isPresented1 = false
        
        @State private var isPresented2 = false

        @State private var item1: TestItem?
        
        @State private var item2: TestItem?
        
        @State private var item3: TestItem?
        
        var body: some View {
            List {
                Section {
                    Button("Toggle isPresented1 (TestItem)") { isPresented1.toggle() }

                    Button("Toggle isPresented2 (String)") { isPresented2.toggle() }
                }
                
                Section {
                    Button("Set item1 (TestItem)") { item1 = .init(id: "Sheet for item1") }

                    Button("Set item2 (String)") { item2 = .init(id: "Sheet for item2") }

                    Button("Set item3 (Identifiable TestItem)") { item3 = .init(id: "Sheet for item3") }
                }
                
            }
            .sheet(isPresented: $isPresented1, value: TestItem(id: "Sheet for isPresented1"))
            .sheet(isPresented: $isPresented2, value: "Sheet for isPresented2")
            .sheet(item: $item1, value: { $0 }) // TestItem
            .sheet(item: $item2, value: { $0.id }) // String
            .sheet(value: $item3)
            .destination(TestDestination())
            .destination(for: String.self) { Text($0) }
            
        }
    }
    
    static var previews: some View {
        Internal()
    }
}
