////
////  MockTests.swift
////  YumeAlamofireTests
////
////  Created by Yume on 2018/6/12.
////  Copyright © 2018年 Yume. All rights reserved.
////
//
//import Foundation
//import XCTest
//import CoreLocation
//
//struct PointOfInterest: Codable, Equatable {
////    let lat: Double
////    let long: Double
//    let name: String
//}
//
//struct PointsOfInterestRequest: APIRequest {
//    func request(from coordinate: CLLocationCoordinate2D) throws -> URLRequest {
//        guard CLLocationCoordinate2DIsValid(coordinate) else {
//            throw NSError(domain: "", code: 0, userInfo: nil)
////                RequestError.invalidCoordinate
//        }
//        var components = URLComponents(string: "https://example.com/locations")!
//        components.queryItems = [
//            URLQueryItem(name: "lat", value: "\(coordinate.latitude)"),
//            URLQueryItem(name: "long", value: "\(coordinate.longitude)")
//        ]
//        return URLRequest(url: components.url!)
//    }
//    
//    func response(data: Data) throws -> [PointOfInterest] {
//        return try JSONDecoder().decode([PointOfInterest].self, from: data)
//    }
//    
//}
//
//class APILoaderTests: XCTestCase {
//    var loader: APIRequestLoader<PointsOfInterestRequest>!
//    override func setUp() {
//        let request = PointsOfInterestRequest()
//        let configuration = URLSessionConfiguration.ephemeral
//        configuration.protocolClasses = [MockURLProtocol.self]
//        let urlSession = URLSession(configuration: configuration)
//        
//        self.loader = APIRequestLoader(apiRequest: request, urlSession: urlSession)
//    }
//    
//    func testLoaderSuccess() {
//        let inputCoordinate = CLLocationCoordinate2D(latitude: 37.3293, longitude: -121.8893)
//        let mockJSONData = "[{\"name\":\"MyPointOfInterest\"}]".data(using: .utf8)!
//        MockURLProtocol.requestHandler = { request in
//            XCTAssertEqual(request.url?.query?.contains("lat=37.3293"), true)
//            return (HTTPURLResponse(), mockJSONData)
//        }
//        let expectation = XCTestExpectation(description: "response")
//        loader.loadAPIRequest(requestData: inputCoordinate) { pointsOfInterest, error in
//            XCTAssertEqual(pointsOfInterest!, [PointOfInterest(name: "MyPointOfInterest")])
//            expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: 1)
//    }
//}
