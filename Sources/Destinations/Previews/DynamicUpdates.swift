//
//  DynamicUpdates.swift
//  
//
//  Created by Mikhail Apurin on 2023/07/27.
//

import SwiftUI

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
struct DynamicUpdates_Persistent_Previews: PreviewProvider {
    struct ContentView: View {
        var body: some View {
            NavigationStack {
                CounterScreen()
            }
            .destination(for: Int.self) { value in
                TimeCounterView(value: value)
            }
        }
    }

    struct CounterScreen: View {
        @State var value = 1

        var body: some View {
            DestinationView(value: value)
                .toolbar {
                    ToolbarItemGroup(placement: .bottomBar) {
                        Stepper("Value: \(value)", value: $value)
                            .padding()
                    }
                }
        }
    }

    struct TimeCounterView: View {
        let value: Int

        @State private var elapsed = 0

        var body: some View {
            List {
                Text("Elapsed: \(elapsed, format: .number)")

                Text("Value: \(value, format: .number)")

                Text("Elapsed + Value = \(elapsed + value, format: .number)")
            }
            .task {
                for await _ in Timer.publish(every: 1, on: .main, in: .common).autoconnect().values {
                    elapsed += 1
                }
            }
        }
    }

    static var previews: some View {
        ContentView()
    }
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
struct DynamicUpdates_Conditional_Previews: PreviewProvider {
    struct ContentView: View {
        @State var base = 1

        var body: some View {
            NavigationStack {
                CounterScreen()
                    .toolbar {
                        ToolbarItemGroup(placement: .navigationBarTrailing) {
                            Stepper("Base: \(base)", value: $base)
                                .padding()
                        }
                    }
            }
            .destination(CustomViewDestination(base: base))
        }
    }

    struct CounterScreen: View {
        @State var value = 1

        var body: some View {
            ZStack {
                if value < 3 {
                    Text("Value is less than 3")
                } else {
                    DestinationView(CustomViewDestination.self, value: value)
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    Stepper("Value: \(value)", value: $value)
                        .padding()
                }
            }
        }
    }

    struct CustomViewDestination: ResolvableDestination {
        let base: Int

        @State var elapsed = 0

        func body(value: Int) -> some View {
            List {
                Text("Elapsed: \(elapsed, format: .number)")

                Text("Base: \(base, format: .number)")

                Text("Value: \(value, format: .number)")

                Text("Elapsed + Base + Value = \(elapsed + base + value, format: .number)")
            }
            .task {
                for await _ in Timer.publish(every: 1, on: .main, in: .common).autoconnect().values {
                    elapsed -= 1
                }
            }
        }
    }

    static var previews: some View {
        ContentView()
    }
}
