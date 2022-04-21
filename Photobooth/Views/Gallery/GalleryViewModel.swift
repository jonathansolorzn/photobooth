//
//  GalleryViewModel.swift
//  Photobooth
//

import Foundation
import Combine

final class GalleryViewModel: ObservableObject {
    
    // MARK: - Declarations
    
    @Published var photos: [Photo] = [] /// [This property is] for show image cats
    @Published private(set) var showEmptyState = false /// [This property is] for show or hide empty state
    var galleryComplete = true /// [This property is] for verify that complete all images request
    
    private let galleryService: GalleryServiceType /// [This property is] the service for get cat data
    private var cancellable = Set<AnyCancellable>() /// [This property is] management to cancel combines
    private var currentPage = Constants.zero /// [This property is] to identify which data page you are on for the request
    
    // MARK: - Init/deinit
    
    init(galleryServiceType: GalleryServiceType) {
        galleryService = galleryServiceType
    }
    
    // MARK: - Methods
    
    /// Use this method to get cats images by tag
    func loadMorePhotos(tag: String) {
        
        showEmptyState = false
        let params = CatParams(
            tag: tag,
            skip: currentPage,
            limit: Constants.galleryLimitPerPage
        )
        
        galleryService.getAll(params: params)
            .sink(
                receiveCompletion: {
                    [weak self] completion in
                    
                    switch completion {
                    case .failure(_):
                        self?.showEmptyState = true
                    case .finished:
                        break
                   }
                },
                receiveValue: {
                    [weak self] cats in
                    
                    self?.photos.append(contentsOf: cats.map { Photo(path: $0.getImageUrl()) })
                    self?.currentPage += Constants.galleryLimitPerPage
                    self?.galleryComplete = cats.count < Constants.galleryLimitPerPage /// Verify that obtaining images finished
                    self?.showEmptyState = self?.photos.isEmpty ?? true
                }
            )
            .store(in: &cancellable)
    }
}

extension GalleryViewModel {
    static func make() -> GalleryViewModel {
        GalleryViewModel(galleryServiceType: Injector.resolve(GalleryServiceType.self))
    }
}
