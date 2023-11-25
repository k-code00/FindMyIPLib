//
//  NetworkManager.swift
//
//
//  Created by Kojo on 22/11/2023.
//

import Foundation
import Alamofire
import Combine

class IPInfoFetcher {
    private var subject = PassthroughSubject<IPInformation, Error>()

    func fetchIPInformation() -> AnyPublisher<IPInformation, Error> {
        let url = "https://ipapi.co/json/"

        AF.request(url).responseDecodable(of: IPInformation.self) { [weak self] response in
            switch response.result {
            case .success(let ipInfo):
                self?.subject.send(ipInfo)
                self?.subject.send(completion: .finished)
            case .failure(let error):
                self?.subject.send(completion: .failure(error))
            }
        }

        return subject.eraseToAnyPublisher()
    }
}
