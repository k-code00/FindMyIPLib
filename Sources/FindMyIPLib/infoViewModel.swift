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
    @Published var showErrorAlert = false

    //storing combine subscriptions
    private var cancellables = Set<AnyCancellable>()
    
    //network manager for fetching IP information
    private var networkManager: IPInfoFetcher

    // initializer with a network manager parameter
    init(networkManager: IPInfoFetcher = IPInfoFetcher()) {
        self.networkManager = networkManager

        //showErrorAlert will be true if the state is failure.
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
    
    //fetching of IP information
    func getIPInformation() {
        //setting state to loading before fetching
        self.state = .loading

        networkManager.fetchIPInformation()
            //verifying the response is handled on the main thread
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                //when complete with no errors nothing happens
                case .finished:
                    break
                    //updating state with failure if error is present
                case .failure(let error):
                    self?.state = .failure(error.localizedDescription)
                }
            }, receiveValue: { [weak self] ipInfo in
                //updating state with success on receiving data
                self?.state = .success(ipInfo)
            })
            //storing the subscription in the cancellables set
            .store(in: &cancellables)
    }
}
