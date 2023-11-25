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
    
    var isFailure: Bool {
        if case .failure(_) = state {
            return true
        } else {
            return false
        }
    }
    
    func getIPInformation() {
        self.state = .loading
        fetchIPInformation { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let info):
                    self?.state = .success(info)
                case .failure(let error):
                    self?.state = .failure(error.localizedDescription)
                }
            }
        }
    }
}
