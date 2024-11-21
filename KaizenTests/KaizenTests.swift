//
//  KaizenTests.swift
//  KaizenTests
//
//  Created by Filip Igrutinovic on 21.11.24..
//

import XCTest
@testable import Kaizen

final class KaizenTests: XCTestCase {
    
    var viewModel: SportsViewModel!
    var mockService: MockNetworkService!
    
    override func setUp() {
        super.setUp()
            
        mockService = MockNetworkService()
        viewModel = SportsViewModel(networkService: mockService)
    }
    
    override func tearDown() {
        viewModel = nil
        mockService = nil
        super.tearDown()
    }
    
    func testNumberOfSections() {
        mockService.mockResult = .success([
            Sport(i: "1", d: "name1", e: []),
            Sport(i: "2", d: "name2", e: [])
        ])
        viewModel.fetchSports()
        XCTAssertEqual(viewModel.numberOfSections, 2)
    }
    
    func testIsCollapsed() {
        mockService.mockResult = .success([
            Sport(i: "1", d: "name1", e: []),
            Sport(i: "2", d: "name2", e: [])
        ])
        viewModel.fetchSports()
        
        viewModel.collapse(of: 1)
        XCTAssertEqual(viewModel.isCollapse(at: 1), true)
    }
    
    func testName() {
        mockService.mockResult = .success([
            Sport(i: "1", d: "name1", e: []),
            Sport(i: "2", d: "name2", e: [])
        ])
        viewModel.fetchSports()
        
        XCTAssertEqual(viewModel.name(of: 0), "name1")
    }
    
    func testCollapse () {
        mockService.mockResult = .success([
            Sport(i: "1", d: "name1", e: []),
            Sport(i: "2", d: "name2", e: [])
        ])
        viewModel.fetchSports()
        viewModel.collapse(of: 1)
        
        XCTAssertEqual(viewModel.isCollapse(at: 1), true)
    }
    
    func testFavoritize() {
        mockService.mockResult = .success([
            Sport(i: "1", d: "name1", e: [Event(i: "1", si: "1", d: "event1", tt: 12345)]),
            Sport(i: "2", d: "name2", e: [Event(i: "2", si: "2", d: "event2", tt: 12345)])
        ])
        viewModel.fetchSports()
        viewModel.favoritize(of: "1")
        let events = viewModel.events(of: 0)
        XCTAssertEqual(events[0].isFavourite, true)
    }
}

class MockNetworkService: NetworkService {
    var mockResult: Result<[Sport], NetworkError>?
    
    override func fetchSports(completion: @escaping (Result<[Sport], NetworkError>) -> Void) {
        if let result = mockResult {
            completion(result)
        }
    }
}
