//
//  LocationTest.swift
//  WeatherAppTests
//
//  Created by Prashant Tukadiya on 29/05/24.
//

import XCTest
import CoreLocation

@testable import WeatherApp

class MockLocationManager:LocationManager {
    var authorizationStatus: CLAuthorizationStatus = .notDetermined
        
    override func fetchLocationPermissionStatus() -> CLAuthorizationStatus {
        return authorizationStatus
    }
}

class MockUserDefaultSaved: UserDefaultSavedLocation {
    
    
    @discardableResult
    override func saveLocation(_ location: SavedLocation) throws -> [SavedLocation] {
        var locations = fetchLocations()
        locations.insert(location, at: 0)
        savedLocations = locations
        return locations
    }
    
    override func deleteLocation(_ location: SavedLocation) {
        var locations = fetchLocations()
        locations.removeAll(where: {$0.id == location.id})
        savedLocations = locations
    }
    
    override func fetchLocations() -> [SavedLocation] {
       return savedLocations
    }
    
    
    
}

final class LocationTest: XCTestCase {

    var viewModel:MyLocationsViewModel!
    var locationManager:MockLocationManager = MockLocationManager()
    var savedLocation = MockUserDefaultSaved()

//    @MainActor
//    override init() {
//        self.viewModel = MyLocationsViewModel()
//        super.init()
//
//    }
    
    @MainActor
    override func setUp() {
        self.viewModel = MyLocationsViewModel(locationManager: locationManager)
        self.viewModel.saveLocation = savedLocation
        XCTAssertTrue(viewModel.isNeedToAskLocationPermission)
    }
    
    @MainActor
    func testDefaultValues() {
        XCTAssertFalse(viewModel.isFetchingCurrentLocation)
      
        XCTAssertFalse(viewModel.askUserToChangeLocationPermission)
        XCTAssertFalse(viewModel.isShowingWeatherScreen)
        XCTAssertNil(viewModel.locationSelected)
        XCTAssertNil(viewModel.showError)

    }
    
    @MainActor
    func testCurrentLocation_PermissionNeedToAsk() {
        if locationManager.authorizationStatus == .notDetermined {
            XCTAssertTrue(viewModel.isNeedToAskLocationPermission)
        } else {
            XCTAssertFalse(viewModel.isNeedToAskLocationPermission)
        }
    }
    
    @MainActor
    func testCurrentLocation_PermissionAllowedChanged() {
        locationManager.authorizationStatus = .authorizedAlways
        viewModel.checkLocationPermissionStatus()
        XCTAssertFalse(viewModel.isNeedToAskLocationPermission)
        XCTAssertFalse(viewModel.askUserToChangeLocationPermission)
    }
    
    @MainActor
    func testCurrentLocation_Permission_NOT_AllowedChanged() {
        locationManager.authorizationStatus = .denied
        viewModel.checkLocationPermissionStatus()
        XCTAssertTrue(viewModel.askUserToChangeLocationPermission)
    }
    
    @MainActor
    func test_FetchingCurrentLocation() async{
        viewModel.isFetchingCurrentLocation = true
        testCurrentLocation_PermissionAllowedChanged()
        XCTAssertTrue(viewModel.isFetchingCurrentLocation)

        let mockLocation = CLLocation(latitude: 19.0515, longitude: 72.05615)
        locationManager.userLocation = mockLocation
        
        viewModel.isFetchingCurrentLocation = false
        viewModel.locationSelected = SavedLocation(lat: mockLocation.coordinate.latitude, lon: mockLocation.coordinate.longitude, originalName: "TEST")
        viewModel.isShowingWeatherScreen = true
        
        XCTAssertFalse(viewModel.isFetchingCurrentLocation)
        XCTAssertNotNil(viewModel.locationSelected)
        XCTAssertEqual(viewModel.locationSelected?.lat, mockLocation.coordinate.latitude)
        XCTAssertEqual(viewModel.locationSelected?.lon, mockLocation.coordinate.longitude)
        XCTAssertTrue(viewModel.isShowingWeatherScreen)
        
    }
    
    @MainActor
    func test_FetchCurrentLocationUserLocationAvailable_WithTheFlow() async {
        let mockLocation = CLLocation(latitude: 19.0515, longitude: 72.05615)
        locationManager.userLocation = mockLocation

        await viewModel.fetchCurrentLocation()
        XCTAssertFalse(viewModel.isFetchingCurrentLocation)
        XCTAssertNotNil(viewModel.locationSelected)
        XCTAssertEqual(viewModel.locationSelected?.lat, mockLocation.coordinate.latitude)
        XCTAssertEqual(viewModel.locationSelected?.lon, mockLocation.coordinate.longitude)
        XCTAssertTrue(viewModel.isShowingWeatherScreen)

    }
    
    @MainActor
    func test_FetchCurrentLocationUserLocation_NOT_Available_Permission_NotALLOWED_WithTheFlow() async {
        locationManager.userLocation = nil
        locationManager.authorizationStatus = .denied

        await viewModel.fetchCurrentLocation()
        XCTAssertTrue(viewModel.askUserToChangeLocationPermission)
        XCTAssertEqual(viewModel.showError,.locationPermission)

        XCTAssertNil(viewModel.locationSelected)
        XCTAssertFalse(viewModel.isShowingWeatherScreen)

    }
    
    @MainActor
    func test_FetchCurrentLocationUserLocation_NOT_Available_Permission_ALLOWED_WithTheFlow() async {
        viewModel.isFetchingCurrentLocation = true
        locationManager.authorizationStatus = .authorizedWhenInUse
        locationManager.userLocation = nil
        await viewModel.fetchCurrentLocation()
        
        XCTAssertFalse(viewModel.askUserToChangeLocationPermission)
        XCTAssertNil(viewModel.locationSelected)
        XCTAssertFalse(viewModel.isShowingWeatherScreen)

    }

    @MainActor
    func testHandleSearchInput()  throws{
        //Given
        let input = "Random Search"
        //when
        viewModel.locationSearch = input
        let expectation = expectation(description: "Search list should be populated")

//        try await Task.sleep(nanoseconds: 1_000_000_000)
        print(viewModel.searchList)
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { // Wait for debounce period
            XCTAssertFalse(self.viewModel.searchList.isEmpty)
            //expectation.fulfill()
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.7)

    }
    
    override func setUpWithError() throws {
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
