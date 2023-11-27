//
//  MockIPInfoFetcher.swift
//
//
//  Created by Kojo on 27/11/2023.
//

import Foundation
import Combine
@testable import FindMyIPLib

class MockIPInfoFetcher: IPInfoFetcher {
    var shouldReturnError: Bool
    var mockIPInformation: IPInformation?

    //initializer with parameters to configure the mock behavior
    init(shouldReturnError: Bool = false, mockIPInformation: IPInformation? = nil) {
        self.shouldReturnError = shouldReturnError
        self.mockIPInformation = mockIPInformation
    }

    //overriding the fetchIPInformation method to provide mock behavior
    override func fetchIPInformation() -> AnyPublisher<IPInformation, Error> {
        //if true return a failure publisher
        if shouldReturnError {
            return Fail(error: NSError(domain: "", code: 0, userInfo: nil))
                .eraseToAnyPublisher()
        } else {
            //return a success publisher with mock data
            return Just(mockIPInformation ?? IPInformation(
                ip: "192.0.2.1",
                version: "IPv4",
                city: "Example City",
                region: "Example Region"
            ))
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        }
    }
}
