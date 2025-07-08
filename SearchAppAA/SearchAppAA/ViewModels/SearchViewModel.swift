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
    @Published private(set) var errorMessage: String?
    @Published private(set) var history: [SearchHistory] = []

    private let api: MovieRepository
    private let historyRepository: HistoryRepository

    private var cancellables = Set<AnyCancellable>()
    private var searchCancellable: AnyCancellable?
    
    init(
        api: MovieRepository = MovieAPI(apiKey: Config.appAPIKey),
        historyRepository: HistoryRepository = UserDefaultsHistoryRepository()
    ) {
        self.api = api
        self.historyRepository = historyRepository

        $query
            .removeDuplicates()
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                Task { await self?.search() }
            }
            .store(in: &cancellables)
        
        loadHistory()
    }
    
    func search(perPage: Int = 5) async {
        guard !query.isEmpty else {
            searchCancellable?.cancel()
            movies = []
            return
        }
        
        errorMessage = nil
        
        searchCancellable?.cancel()
        searchCancellable = api.searchMovies(query: query, page: 1, perPage: perPage)
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] movies in
                self?.movies = movies
            }
    }
    
    func showMore() async {
        await search(perPage: AppLayout.maxResultsCount)
    }
    
    func addHistory(movie: Movie) {
        guard !history.contains(where: { $0.movie.id == movie.id }) else { return }
        let searchHistory = SearchHistory(movie: movie, date: Date())
        history.insert(searchHistory, at: 0)
        if history.count > AppLayout.maxResultsCount {
            history.removeLast(history.count - AppLayout.maxResultsCount)
        }
        saveHistory()
    }
    
    private func loadHistory() {
        history = historyRepository.load()
    }
    
    private func saveHistory() {
        historyRepository.save(history: history)
    }
}
