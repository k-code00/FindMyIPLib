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
            if viewModel.isLoading {
                ProgressView()
                    .scaleEffect(1.5)
                    .padding()
            } else if let ipInfo = viewModel.ipInformation {
                Section(header: Text("IP Address")) {
                    Menu {
                        Button(action: {}) {
                            Text("Version: \(ipInfo.version )")
                        }
                        Button(action: {}) {
                            Text("City: \(ipInfo.city )")
                        }
                        Button(action: {}) {
                            Text("Region: \(ipInfo.region )")
                        }
                    } label: {
                        HStack {
                            Text(ipInfo.ip )
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
            } else if viewModel.errorMessage != nil {
                Section {
                    Text("Error: Refresh To Find IP")
                        .foregroundColor(.red)
                }
            }
        }
        .refreshable {
            viewModel.getIPInformation()
        }
        .onAppear {
            viewModel.getIPInformation()
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(
                title: Text("Error"),
                message: Text("Cannot Find IP"),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

