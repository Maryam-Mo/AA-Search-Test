//
//  SearchViewModel.swift
//  SearchAppAA
//
//  Created by Maryam on 7/8/25.
//

import Foundation
import Combine

@MainActor
class SearchViewModel: ObservableObject {
    @Published var query: String = ""
    @Published private(set) var movies: [Movie] = []
    
    private let api: MovieRepository
    
    private var cancellables = Set<AnyCancellable>()
    private var searchCancellable: AnyCancellable?
    
    init(api: MovieAPI = MovieAPI(apiKey: Config.appAPIKey)) {
        self.api = api
        
        $query
            .removeDuplicates()
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                Task { await self?.search() }
            }
            .store(in: &cancellables)
    }
    
    func search(perPage: Int = 5) async {
        guard !query.isEmpty else {
            searchCancellable?.cancel()
            movies = []
            return
        }
        
        searchCancellable?.cancel()
        searchCancellable = api.searchMovies(query: query, page: 1, perPage: perPage)
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
            } receiveValue: { [weak self] movies in
                self?.movies = movies
            }
    }
}
