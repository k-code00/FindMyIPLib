//
//  testInfoViewModel.swift
//  
//
//  Created by Kojo on 27/11/2023.
//

import XCTest
import Combine
@testable import FindMyIPLib

final class testInfoViewModel: XCTestCase {

    private var cancellables: Set<AnyCancellable>!

    override func setUpWithError() throws {
        cancellables = []
    }

    override func tearDownWithError() throws {
        cancellables = nil
    }

    func testInfoViewModel_SuccessState() throws {
        let mockIPInformation = IPInformation(
            ip: "192.0.2.1",
            version: "IPv4",
            city: "Example City",
            region: "Example Region"
        )
        let mockFetcher = MockIPInfoFetcher(mockIPInformation: mockIPInformation)
        let viewModel = infoViewModel(networkManager: mockFetcher)

        let expectation = XCTestExpectation(description: "Success State")

        viewModel.$state.sink { state in
            if case .success(let ipInfo) = state {
                XCTAssertEqual(ipInfo, mockIPInformation)
                expectation.fulfill()
            }
        }.store(in: &cancellables)

        viewModel.getIPInformation()

        wait(for: [expectation], timeout: 5.0)
    }

    func testInfoViewModel_FailureState() throws {
        let mockFetcher = MockIPInfoFetcher(shouldReturnError: true)
        let viewModel = infoViewModel(networkManager: mockFetcher)

        let expectation = XCTestExpectation(description: "Failure State")

        viewModel.$state.sink { state in
            if case .failure(_) = state {
                XCTAssertTrue(viewModel.showErrorAlert)
                expectation.fulfill()
            }
        }.store(in: &cancellables)

        viewModel.getIPInformation()

        wait(for: [expectation], timeout: 5.0)
    }
}

extension IPInformation: Equatable {
    public static func == (lhs: IPInformation, rhs: IPInformation) -> Bool {
        return lhs.ip == rhs.ip &&
               lhs.version == rhs.version &&
               lhs.city == rhs.city &&
               lhs.region == rhs.region
    }
}
