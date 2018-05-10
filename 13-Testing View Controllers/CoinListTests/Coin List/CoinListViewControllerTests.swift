//
//  CoinListViewControllerTests.swift
//  CoinListTests
//
//  Created by Ben Scheirman on 4/30/18.
//  Copyright © 2018 Fickle Bits, LLC. All rights reserved.
//

import Foundation
import XCTest
@testable import CoinList

class MockCryptoClient : CryptoCompareClient {
    var fetchCallCount: Int = 0
    var completeWithResult: ApiResult<CoinList>?
    var delay: TimeInterval = 1
    var fetchExpectation: XCTestExpectation?
    
    init(completingWith result: ApiResult<CoinList>? = nil) {
        super.init(session: URLSession.shared)
        completeWithResult = result
    }
    
    override func fetchCoinList(completion: @escaping (ApiResult<CoinList>) -> Void) {
        fetchCallCount += 1
        
        guard let completeWithResult = self.completeWithResult else { return }
        
        fetchExpectation = XCTestExpectation(description: "coin list retrieved")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            completion(completeWithResult)
            self.fetchExpectation?.fulfill()
        }
    }
    
    func verifyFetchCalled(file: StaticString = #file, line: UInt = #line) {
        XCTAssert(fetchCallCount == 1, "Fetch call count was not called", file: file, line: line)
    }
}

class CoinListViewControllerTests : XCTestCase {
    
    var viewController: CoinListViewController!
    
    override func setUp() {
        super.setUp()
        
        viewController = CoinListViewController.makeFromStoryboard()
    }
    
    func testFetchesCoinsWhenLoaded() {
        let mockClient = MockCryptoClient()
        viewController.cryptoCompareClient = mockClient
        _ = viewController.view
        mockClient.verifyFetchCalled()
    }
    
    func testShowsLoadingIndicatorWhileFetching() {
        let mockClient = MockCryptoClient()
        viewController.cryptoCompareClient = mockClient
        _ = viewController.view
        XCTAssert(viewController.activityIndicator.isAnimating)
    }
    
    func testLoadingIndicatorHidesWhenFetchCompletes() {
        let coinList = emptyCoinList()
        let mockClient = MockCryptoClient(completingWith: .success(coinList))
        viewController.cryptoCompareClient = mockClient
        _ = viewController.view
        wait(for: [mockClient.fetchExpectation!], timeout: 3.0)
        XCTAssertFalse(viewController.activityIndicator.isAnimating)
    }
    
    
    
    private func emptyCoinList() -> CoinList {
        return CoinList(response: "",
                 message: "",
                 baseImageURL: URL(string: "http://foo.com")!,
                 baseLinkURL: URL(string: "http://foo.com")!, data: CoinList.Data(coins: []))
    }
    
    
    
}
