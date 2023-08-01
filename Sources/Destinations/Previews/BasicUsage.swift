//
//  BasicUsage.swift
//  
//
//  Created by Mikhail Apurin on 2023/07/27.
//

import SwiftUI

struct BasicUsage_Closure_Previews: PreviewProvider {
    struct ParentView: View {
        var body: some View {
            ChildView()
                .destination(for: Int.self) { value in
                    Text(100 + value, format: .number)
                }
        }
    }

    struct ChildView: View {
        var body: some View {
            DestinationView(value: 1)
        }
    }

    static var previews: some View {
        ParentView()
    }
}


struct BasicUsage_Destination_Previews: PreviewProvider {
    struct MyDestination: ResolvableDestination {
        let base: Int

        func body(value: Int) -> some View {
            Text(base + value, format: .number)
        }
    }

    struct ParentView: View {
        var body: some View {
            ChildView()
                .destination(MyDestination(base: 100))
        }
    }

    struct ChildView: View {
        var body: some View {
            DestinationView(value: 1)
        }
    }

    static var previews: some View {
        ParentView()
    }
}
