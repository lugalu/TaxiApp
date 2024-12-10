//Created by Lugalu on 06/12/24.

import Testing
import XCTest
@testable import TaxiApp

fileprivate struct EstimateBody: Decodable {
    let customer_id: String
    let origin: String
    let destination: String
}

struct EndpointBuilderTests {
    
    
    @Test func testEstimateURL() async throws {
        let estimateOption =  NetworkOptions.rideEstimate(id: "CT01", start: "lugalu", end: "lugalu")
        let request = try EndpointBuilder.build(for: estimateOption)
        let stringURL = request.url?.absoluteString
        XCTAssertNotNil(stringURL)
        #expect(stringURL == "https://xd5zl5kk2yltomvw5fb37y3bm40vsyrx.lambda-url.sa-east-1.on.aws/ride/estimate")
    }
    
    @Test func testEstimateBody() async throws {
        let estimateOption =  NetworkOptions.rideEstimate(id: "CT01", start: "lugalu", end: "lugalu")
        let request = try EndpointBuilder.build(for: estimateOption)
        XCTAssertNotNil(request.httpBody)
        let decoded = try DecoderService().decode(request.httpBody!, class: EstimateBody.self)
        
        #expect(decoded.customer_id == "CT01")
        #expect(decoded.origin == "lugalu")
        #expect(decoded.destination == "lugalu")
    }
    
    @Test func testConfirmURL() async throws {
        let testData = RideConfirmationBody(id: "CT01",
                                            origin: "lugalu",
                                            destination: "lugalu",
                                            distance: 20,
                                            duration: "20:40",
                                            driverID: 1,
                                            driverName: "lugalu",
                                            value: 50)
        
        
        let confirmOption =  NetworkOptions.confirm(rideData: testData)
        let request = try EndpointBuilder.build(for: confirmOption)
        let stringURL = request.url?.absoluteString
        XCTAssertNotNil(stringURL)
        #expect(stringURL == "https://xd5zl5kk2yltomvw5fb37y3bm40vsyrx.lambda-url.sa-east-1.on.aws/ride/confirm")
    }
    
    @Test func testConfirmBody() async throws {
        let testData = RideConfirmationBody(id: "CT01",
                                            origin: "lugalu",
                                            destination: "lugalu",
                                            distance: 20,
                                            duration: "20:40",
                                            driverID: 1,
                                            driverName: "lugalu",
                                            value: 50)
        
        
        let confirmOption =  NetworkOptions.confirm(rideData: testData)
        let request = try EndpointBuilder.build(for: confirmOption)
        XCTAssertNotNil(request.httpBody)
        let decoded = try DecoderService().decode(request.httpBody!, class: RideConfirmationBody.self)
        #expect(decoded == testData)
    }
    
    @Test func testListURL() async throws {
        let listOption = NetworkOptions.list(id: "CT01", driverID: 1)
        let request = try EndpointBuilder.build(for: listOption)
        let stringURL = request.url?.absoluteString
        XCTAssertNotNil(stringURL)
        #expect(stringURL == "https://xd5zl5kk2yltomvw5fb37y3bm40vsyrx.lambda-url.sa-east-1.on.aws/ride/CT01?driver_id=1")
    }
}
