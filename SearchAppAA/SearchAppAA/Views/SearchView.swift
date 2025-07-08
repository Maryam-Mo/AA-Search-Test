//
//  ContentView.swift
//  SearchAppAA
//
//  Created by Maryam on 7/4/25.
//

import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                let total = geometry.size.height - geometry.safeAreaInsets.top - geometry.safeAreaInsets.bottom
                let half = (total - AppLayout.searchContentSpacing) / 2
                
                ZStack {
                    VStack(spacing: AppLayout.searchContentSpacing) {
                        
                        HeaderView(viewModel: viewModel, height: half)
                        
                        ZStack(alignment: .top) {
                            if !viewModel.movies.isEmpty {
                                MovieListView(viewModel: viewModel, height: half)
                            }
                        }
                        .frame(height: half, alignment: .top)
                        
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.horizontal, AppLayout.defaultPadding)
                .background(AppColors.background)
                .navigationBarHidden(true)
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .tint(AppColors.textPrimary)
    }
}

struct HeaderView: View {
    @ObservedObject var viewModel: SearchViewModel
    let height: CGFloat
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: AppLayout.smallVerticalSpacing) {
                Image("SearchIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(height: height * 0.3)
                
                IndicatorView()
                
                Spacer().frame(height: AppLayout.smallVerticalSpacing)
                
                Text("Search for a movie")
                    .font(AppFonts.title2)
                    .foregroundColor(AppColors.textPrimary)
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
            .padding(.bottom, AppLayout.defaultPadding)
            
            SearchBar(query: $viewModel.query) {
                Task { await viewModel.search() }
            }
            .frame(minHeight: AppLayout.searchHeight)
            .frame(maxWidth: .infinity)
        }
        .frame(height: height)
    }
}

struct SearchBar: View {
    @Binding var query: String
    var onCommit: () -> Void
    
    var body: some View {
        HStack {
            ZStack(alignment: .leading) {
                if query.isEmpty {
                    Text("Search...")
                        .font(AppFonts.title16)
                        .foregroundColor(AppColors.textSecondary)
                }
                TextField("", text: $query, onCommit: onCommit)
                    .font(AppFonts.title16)
                    .foregroundColor(AppColors.textPrimary)
                    .tint(AppColors.textPrimary)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(RoundedRectangle(cornerRadius: AppLayout.cornerRadius).stroke(AppColors.bodySecondary, lineWidth: 1))
    }
}

struct IndicatorView: View {
    var body: some View {
        HStack(spacing: AppLayout.indicatorSpacing) {
            Capsule().fill(AppColors.indicatorActive).frame(width: AppLayout.indicatorActiveWidth, height: AppLayout.indicatorHeight)
            Capsule().fill(AppColors.indicatorInactive).frame(width: AppLayout.indicatorInactiveWidth, height: AppLayout.indicatorHeight)
            Capsule().fill(AppColors.indicatorInactive).frame(width: AppLayout.indicatorInactiveWidth, height: AppLayout.indicatorHeight)
        }
    }
}

struct MovieListView: View {
    @ObservedObject var viewModel: SearchViewModel
    let height: CGFloat
    @State private var selectedMovie: Movie?
    @State private var contentHeight: CGFloat = .zero
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                ForEach(viewModel.movies) { movie in
                    movieRow(for: movie)
                }
                if viewModel.movies.count <= AppLayout.defaultResultsCount {
                    ShowMoreButton {
                        Task { await viewModel.showMore() }
                    }
                }
            }
            .padding(.top, AppLayout.defaultPadding)
            .background(
                GeometryReader { geometry in
                    Color.clear
                        .preference(key: ContentHeightKey.self,
                                    value: geometry.size.height)
                }
            )
        }
        .frame(height: min(contentHeight, height))
        .background(AppColors.listBackground)
        .cornerRadius(AppLayout.cornerRadius)
        .onPreferenceChange(ContentHeightKey.self) {
            contentHeight = $0
        }
        .background(
            Group {
                if let movie = selectedMovie {
                    NavigationLink(
                        destination: DetailView(movie: movie),
                        isActive: Binding(
                            get: { selectedMovie != nil },
                            set: { if !$0 { selectedMovie = nil } }
                        ),
                        label: { EmptyView() }
                    )
                    .hidden()
                }
            }
        )
    }
    
    
    @ViewBuilder
    private func movieRow(for movie: Movie) -> some View {
        Button {
            selectedMovie = movie
        } label: {
            Text(movie.title)
                .font(AppFonts.headline)
                .foregroundColor(AppColors.textPrimary)
                .padding(.bottom, AppLayout.defaultPadding)
                .padding(.horizontal, AppLayout.defaultPadding)
        }
        .buttonStyle(.plain)
    }
}

struct ShowMoreButton: View {
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            Text("Show more")
                .font(AppFonts.title16)
                .frame(maxWidth: .infinity)
                .padding()
                .background(.clear)
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .stroke(AppColors.textSecondary, lineWidth: 1)
                )
                .foregroundColor(AppColors.textSecondary)
        }
        .padding(.bottom, AppLayout.defaultPadding)
        .padding(.horizontal, AppLayout.defaultPadding)
    }
}

#Preview {
    SearchView()
}

fileprivate struct ContentHeightKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}
