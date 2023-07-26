//
//  View+Destinations.swift
//  
//
//  Created by Mikhail Apurin on 22.07.2023.
//

import SwiftUI

extension View {
    public func sheet<Destination: ResolvableDestination>(
        isPresented: Binding<Bool>,
        onDismiss: (() -> Void)? = nil,
        destination: Destination.Type,
        value: Destination.Value
    ) -> some View {
        self.sheet(isPresented: isPresented, onDismiss: onDismiss) {
            ResolvedView(destination: Destination.self, value: value)
        }
    }

    public func sheet<Item: Identifiable, Destination: ResolvableDestination>(
        item: Binding<Item?>,
        onDismiss: (() -> Void)? = nil,
        destination: Destination.Type,
        value: @escaping (Item) -> Destination.Value
    ) -> some View {
        self.sheet(item: item, onDismiss: onDismiss) { item in
            ResolvedView(destination: Destination.self, value: value(item))
        }
    }

    public func sheet<Destination: ResolvableDestination>(
        item: Binding<Destination.Value?>,
        onDismiss: (() -> Void)? = nil,
        destination: Destination.Type
    ) -> some View where Destination.Value: Identifiable {
        self.sheet(item: item, onDismiss: onDismiss) { item in
            ResolvedView(destination: Destination.self, value: item)
        }
    }
}

extension View {
    public func sheet<Value: Hashable>(
        isPresented: Binding<Bool>,
        onDismiss: (() -> Void)? = nil,
        value: Value
    ) -> some View {
        self.sheet(isPresented: isPresented, onDismiss: onDismiss) {
            ResolvedView(destination: ValueDestination.self, value: value)
        }
    }

    public func sheet<Item: Identifiable, Value: Hashable>(
        item: Binding<Item?>,
        onDismiss: (() -> Void)? = nil,
        value: @escaping (Item) -> Value
    ) -> some View {
        self.sheet(item: item, onDismiss: onDismiss) { item in
            ResolvedView(destination: ValueDestination.self, value: value(item))
        }
    }

    public func sheet<Value: Hashable>(
        value: Binding<Value?>,
        onDismiss: (() -> Void)? = nil
    ) -> some View where Value: Identifiable {
        self.sheet(item: value, onDismiss: onDismiss) { value in
            ResolvedView(destination: ValueDestination.self, value: value)
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
        
        @State private var item4: TestItem?
        
        var body: some View {
            List {
                Section {
                    Button("Toggle isPresented1") { isPresented1.toggle() }
                    
                    Button("Set item1") { item1 = .init(id: "Sheet for item1") }
                    
                    Button("Set item2") { item2 = .init(id: "Sheet for item2") }
                }
                
                Section {
                    Button("Toggle isPresented2") { isPresented2.toggle() }
                    
                    Button("Set item3") { item3 = .init(id: "Sheet for item3") }
                    
                    Button("Set item4") { item4 = .init(id: "Sheet for item4") }
                }
                
            }
            .sheet(isPresented: $isPresented1, destination: TestDestination.self, value: .init(id: "Sheet for isPresented1"))
            .sheet(isPresented: $isPresented2, value: TestItem(id: "Sheet for isPresented2"))
            .sheet(item: $item1, destination: TestDestination.self, value: { $0 })
            .sheet(item: $item2, destination: TestDestination.self)
            .sheet(item: $item3, value: { $0 })
            .sheet(value: $item4)
            .destination(TestDestination())
            .destination(for: TestItem.self) { Text($0.id) }
            
        }
    }
    
    static var previews: some View {
        Internal()
    }
}
