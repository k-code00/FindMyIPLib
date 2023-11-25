//
//  ipView.swift
//  MainApp
//
//  Created by Kojo on 22/11/2023.
//

import SwiftUI

public struct ipView: View {
    @StateObject private var viewModel = infoViewModel()

    public init() { }

    public var body: some View {
        List {
            switch viewModel.state {
            case .loading:
                ProgressView()
                    .scaleEffect(1.5)
                    .padding()
            case .success(let ipInfo):
                Section(header: Text("IP Address")) {
                    Menu {
                        Button(action: {}) {
                            Text("Version: \(ipInfo.version)")
                        }
                        Button(action: {}) {
                            Text("City: \(ipInfo.city)")
                        }
                        Button(action: {}) {
                            Text("Region: \(ipInfo.region)")
                        }
                    } label: {
                        HStack {
                            Text(ipInfo.ip)
                                .fontWeight(.light)
                                .foregroundColor(.blue)
                            Spacer()
                            Image(systemName: "chevron.down")
                                .foregroundColor(.blue)
                        }
                        .padding()
                    }
                    .menuStyle(DefaultMenuStyle())
                }
            case .failure(let errorMessage):
                Section {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                }
            case .idle:
                ProgressView("Loading...")
            }
        }
        .refreshable {
            viewModel.getIPInformation()
        }
        .onAppear {
            viewModel.getIPInformation()
        }
        .alert(isPresented: $viewModel.showErrorAlert) {
            guard case let .failure(errorMessage) = viewModel.state else {
                return Alert(title: Text("Error"), message: Text("Unknown Error"), dismissButton: .default(Text("OK")))
            }
            return Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
        }

    }
}
