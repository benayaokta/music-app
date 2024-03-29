//
//  BCAMusicPlayerTests.swift
//  BCAMusicPlayerTests
//
//  Created by Benaya Oktavianus on 27/01/24.
//

import XCTest
@testable import BCAMusicPlayer

final class BCAMusicPlayerTests: XCTestCase {

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
    
    func test_homeIsLoaded() throws {
        let sut = HomeInjection.provideHomeViewController()
        sut.loadViewIfNeeded()
        XCTAssertNotNil(sut.view)
        XCTAssertNotNil(sut.viewModel)
    }
    
    func test_isPlayingDidToggleTrue() throws {
        let audio = AudioHelper.shared
        audio.play()
        XCTAssert(AudioHelper.shared.isPlaying, "Should be true")
    }
    
    func test_isPlayingDidToggleFalse() throws {
        let audio = AudioHelper.shared
        audio.pause()
        XCTAssert(AudioHelper.shared.isPlaying == false, "Should be false when pausing, no change variable")
    }
    
    func test_isPlayingFalseOnStart() throws {
        let audio = AudioHelper.shared
        XCTAssert(AudioHelper.shared.isPlaying == false, "Should be false on start")
    }

}
