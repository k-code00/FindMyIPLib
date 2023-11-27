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

    //set for storing Combine subscriptions
    private var cancellables: Set<AnyCancellable>!

    override func setUpWithError() throws {
        cancellables = []
    }

    override func tearDownWithError() throws {
        cancellables = nil
    }

    //testing for successful state handling in the view model
    func testInfoViewModel_SuccessState() throws {

        //mock data for testing
        let mockIPInformation = IPInformation(
            ip: "192.0.2.1",
            version: "IPv4",
            city: "Example City",
            region: "Example Region"
        )
        
        //mock network
        let mockFetcher = MockIPInfoFetcher(mockIPInformation: mockIPInformation)
        let viewModel = infoViewModel(networkManager: mockFetcher)

        //expectation waiting for asynchronous code
        let expectation = XCTestExpectation(description: "Success State")

        //suscribing to the view models state changes
        viewModel.$state.sink { state in
            if case .success(let ipInfo) = state {
                XCTAssertEqual(ipInfo, mockIPInformation)
                expectation.fulfill()
            }
        }.store(in: &cancellables)
        
        //fetching ip information
        viewModel.getIPInformation()

        //set timer for expectation to be fulfilled
        wait(for: [expectation], timeout: 5.0)
    }
    
    //testing for failure state handling in the view model
    func testInfoViewModel_FailureState() throws {

        //mock network
        let mockFetcher = MockIPInfoFetcher(shouldReturnError: true)
        let viewModel = infoViewModel(networkManager: mockFetcher)

        //expectation waiting for asynchronous code
        let expectation = XCTestExpectation(description: "Failure State")

        //subscribing to view models state changes
        viewModel.$state.sink { state in
            if case .failure(_) = state {
                //alert is shown on failure
                XCTAssertTrue(viewModel.showErrorAlert)
                expectation.fulfill()
            }
        }.store(in: &cancellables)

        //fetching ip information
        viewModel.getIPInformation()

        //set timer for expectation to be fulfilled
        wait(for: [expectation], timeout: 5.0)
    }
}

//conforming ipinfomation to equatable
extension IPInformation: Equatable {
    public static func == (lhs: IPInformation, rhs: IPInformation) -> Bool {
        return lhs.ip == rhs.ip &&
               lhs.version == rhs.version &&
               lhs.city == rhs.city &&
               lhs.region == rhs.region
    }
}
