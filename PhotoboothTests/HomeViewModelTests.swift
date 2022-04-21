//
//  HomeViewModelTests.swift
//  PhotoboothTests
//
//  Created by Jonathan Solorzano on 20/4/22.
//

import XCTest
import Moya
@testable import Photobooth

class HomeViewModelTests: XCTestCase {
    
    var sut: HomeViewModel!
    
    override func setUpWithError() throws {
        
        let moyaProvider = MoyaProvider<GalleryAPI>(
            stubClosure: MoyaProvider.immediatelyStub,
            plugins: [
                NetworkLoggerPlugin(
                    configuration: NetworkLoggerPlugin.Configuration(logOptions: .verbose)
                )
            ]
        )
        let galleryService = GalleryNetworkService(provider: moyaProvider)
        sut = HomeViewModel(galleryServiceType: galleryService)
        
    }
    
    // 1. Should add N amount of items to tags array
    // 2. Show empty state should be false
    func test_loadTags() throws {
        
        sut.loadTags(shouldLoadSections: false)
        
        XCTAssertFalse(sut.tags.isEmpty, "Tags should have been filled")
        XCTAssertFalse(sut.showEmptyState, "Show empty state should be false")
    }
    
    // 1. Should add Constants.homeTagsPerPage to sections array
    // 2. Should decrease the amount of elements in tags array
    func test_loadSections() throws {
        
        sut.resetVariables()
        // this method will call loadSections function
        sut.loadTags(shouldLoadSections: true)
        
        XCTAssertFalse(sut.sections.isEmpty, "Sections should have been filled")
        XCTAssertTrue(sut.tags.isEmpty, "Pending tags should be empty after loading all the sections")
    }
}
