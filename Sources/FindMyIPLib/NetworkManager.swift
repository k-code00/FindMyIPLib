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
    //a subject that can emit IPInformation or error
    private var subject = PassthroughSubject<IPInformation, Error>()

    //func to fetch IP info and return a publisher
    func fetchIPInformation() -> AnyPublisher<IPInformation, Error> {
        let url = "https://ipapi.co/json/"

        //AF request to fetch data from the url
        AF.request(url).responseDecodable(of: IPInformation.self) { [weak self] response in
            switch response.result {
            case .success(let ipInfo):
                self?.subject.send(ipInfo)
                self?.subject.send(completion: .finished)
            case .failure(let error):
                self?.subject.send(completion: .failure(error))
            }
        }

        //return the subject as an AnyPublisher to be used by subscribers
        return subject.eraseToAnyPublisher()
    }
}
