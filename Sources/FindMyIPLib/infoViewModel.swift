//
//  infoViewModel.swift
//
//
//  Created by Kojo on 22/11/2023.
//

import Foundation
import Combine

enum InfoViewState {
    case idle
    case loading
    case success(IPInformation)
    case failure(String)
}

class infoViewModel: ObservableObject {
    @Published var state: InfoViewState = .idle
    @Published var showErrorAlert = false // New property for alert visibility
    private var cancellables = Set<AnyCancellable>()
    private var networkManager: IPInfoFetcher

    init(networkManager: IPInfoFetcher = IPInfoFetcher()) {
        self.networkManager = networkManager

        $state
            .map { state in
                if case .failure(_) = state {
                    return true
                } else {
                    return false
                }
            }
            .assign(to: &$showErrorAlert)
    }
    
    func getIPInformation() {
        self.state = .loading

        networkManager.fetchIPInformation()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.state = .failure(error.localizedDescription)
                }
            }, receiveValue: { [weak self] ipInfo in
                self?.state = .success(ipInfo)
            })
            .store(in: &cancellables)
    }
}
