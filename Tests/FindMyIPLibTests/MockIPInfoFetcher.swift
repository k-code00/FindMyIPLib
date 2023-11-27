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

    init(shouldReturnError: Bool = false, mockIPInformation: IPInformation? = nil) {
        self.shouldReturnError = shouldReturnError
        self.mockIPInformation = mockIPInformation
    }

    override func fetchIPInformation() -> AnyPublisher<IPInformation, Error> {
        if shouldReturnError {
            return Fail(error: NSError(domain: "", code: 0, userInfo: nil))
                .eraseToAnyPublisher()
        } else {
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
