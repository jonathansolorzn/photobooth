//
//  GalleryViewModelTests.swift
//  PhotoboothTests
//
//  Created by Jonathan Solorzano on 20/4/22.
//

import XCTest
import Moya
@testable import Photobooth

class GalleryViewModelTests: XCTestCase {

    var sut: GalleryViewModel!
    
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
        sut = GalleryViewModel(galleryServiceType: galleryService)
        
    }
    
    func test_loadCatPhotos() throws {
        
        sut.loadMorePhotos(tag: "Black")
        
        XCTAssertFalse(sut.showEmptyState, "If photos were loaded, this should be false")
        XCTAssertFalse(sut.photos.isEmpty, "After loading photos, the array should not be empty")
    }

}
