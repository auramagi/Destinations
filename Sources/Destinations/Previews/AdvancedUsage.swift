//
//  AdvancedUsage.swift
//  
//
//  Created by Mikhail Apurin on 2023/07/27.
//

import SwiftUI

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
struct AdvancedUsage_Navigation_Previews: PreviewProvider {
    struct MyDestination: ResolvableDestination {
        func body(value: String) -> some View {
            Text(value)
        }
    }
    
    struct ContentView: View {
        @State var isSheetPresented = false

        var body: some View {
            NavigationStack {
                List {
                    DestinationNavigationLink(
                        "Present MyDestination with push transition",
                        value: "Hello, world!"
                    )

                    Button("Present MyDestination modally") {
                        isSheetPresented.toggle()
                    }
                }
            }
            .sheet(
                isPresented: $isSheetPresented,
                value: "Hello, modal world!"
            )
            .destination(MyDestination())
        }
    }

    static var previews: some View {
        ContentView()
    }
}

#if !os(tvOS) && !os(watchOS)
@available(iOS 16.0, macOS 13.0, watchOS 9.0, *)
struct AdvancedUsage_State_Previews: PreviewProvider {
    struct FileSizeLabelDestination: ResolvableDestination {
        @State private var fileSize: Result<Int, Error>?

        let calculateFileSize: (URL) throws -> Int

        func body(value: URL) -> some View {
            Group {
                switch fileSize {
                case .none:
                    ProgressView()

                case let .success(size):
                    Text(
                        Measurement(value: Double(size), unit: UnitInformationStorage.bytes),
                        format: .byteCount(style: .file)
                    )

                case let .failure(error):
                    Text(error.localizedDescription)
                }
            }
            .task(id: value) {
                fileSize = .init { try calculateFileSize(value) }
            }
        }
    }

    struct ContentView: View {
        @State private var url: URL?

        @State private var isFileImporterPresented = false

        var body: some View {
            Button {
                isFileImporterPresented.toggle()
            } label: {
                LabeledContent {
                    if let url {
                        DestinationView(value: url)
                    }
                } label: {
                    Text(url?.absoluteString ?? "Select file")
                }
            }
            .fileImporter(isPresented: $isFileImporterPresented, allowedContentTypes: [.data]) {
                do {
                    url = try $0.get()
                } catch {
                    print("File selection error:", error)
                }
            }
        }
    }

    static var previews: some View {
        List {
            Section("Live") {
                ContentView()
                    .destination(
                        FileSizeLabelDestination(
                            calculateFileSize: { url in
                                _ = url.startAccessingSecurityScopedResource()
                                defer { url.stopAccessingSecurityScopedResource() }
                                return try url.resourceValues(forKeys: [.fileSizeKey]).fileSize ?? 0
                            }
                        )
                    )
            }

            Section("Mocked") {
                ContentView()
                    .destination(
                        FileSizeLabelDestination(
                            calculateFileSize: { _ in 123 }
                        )
                    )
            }
        }
    }
}
#endif
