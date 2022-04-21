//
//  ViewModel.swift
//  Photobooth
//

import Foundation
import Combine

final class HomeViewModel: ObservableObject {
    
    // MARK: - Declarations
    
    @Published var sections: [SectionModel] = [] /// [This property is] for show cats by tag
    @Published private(set) var showEmptyState = false
    
    private let galleryService: GalleryServiceType /// [This property is] the service for get cat data
    private var cancellable = Set<AnyCancellable>() /// [This property is] management to cancel combines
    private var skip = Constants.zero /// [This property is] to identify which data page you are on for the request
    private(set) var tags: [String] = [] /// [This property is] the cat tags
    
    // MARK: - Init/deinit
    
    init(galleryServiceType: GalleryServiceType) {
        galleryService = galleryServiceType
    }
    
    // MARK: - Methods
    
    /// Use this method to load cat tags
    func loadTags(shouldLoadSections: Bool = true) {
        
        showEmptyState = false
        galleryService.getTags()
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
                    [weak self] items in
                    
                    self?.showEmptyState = items.isEmpty
                    
                    if !items.isEmpty {
                        self?.tags = items
                        
                        if shouldLoadSections {
                            self?.loadSections()
                        }
                    }
                }
            )
            .store(in: &cancellable)
    }
    
    /// Use this method to generate sections cats by tag with pagination
    func loadSections() {
        /// Check the available tags to obtain the data limit to request
        let nextLastTagIndex = nextLastTagIndex(tagsCount: tags.count)
        let range = Constants.zero...nextLastTagIndex /// Range of requests to perform
        
        range.forEach { loadCats(tag: tags[$0]) } // Invoke function to get cats by current loop tag
        tags.removeSubrange(range) // Remove requested tags
        skip += Constants.homeTagsPerPage
    }
    
    func resetVariables() {
        tags = []
        sections = []
        skip = Constants.zero
        showEmptyState = false
    }
    
    // MARK: - Helpers
    
    /// Calculates next last tag index of the tags array
    private func nextLastTagIndex(tagsCount: Int) -> Int {
        
        if tagsCount > Constants.homeTagsPerPage {
            return Constants.homeTagsPerPage
        }
        
        return tagsCount - 1
    }
    
    /// Use this method to get cats by tag
    private func loadCats(tag: String) {
        
        let params = CatParams(
            tag: tag,
            limit: Constants.homeTagsPerPage
        )
        
        galleryService.getAll(params: params)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: {
                    [weak self] cats in
                    
                    if !cats.isEmpty {
                        /// Create new array with the cat image url
                        let images = cats.map { Photo(path: $0.getImageUrl()) }
                        let sectionModel = SectionModel(
                            tag: tag,
                            photos: images
                        )
                        
                        self?.sections.append(sectionModel) /// Add new section to array variable
                    }
                    self?.showEmptyState = self?.sections.isEmpty ?? true
                }
            )
            .store(in: &cancellable)
    }
}

extension HomeViewModel {
    static func make() -> HomeViewModel {
        HomeViewModel(galleryServiceType: Injector.resolve(GalleryServiceType.self))
    }
}
