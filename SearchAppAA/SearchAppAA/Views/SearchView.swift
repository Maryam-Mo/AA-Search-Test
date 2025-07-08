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
                            .frame(height: half)
                        
                        ZStack {
                        }
                        .frame(height: half)

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
    }
}

struct HeaderView: View {
    @ObservedObject var viewModel: SearchViewModel
    let height: CGFloat
    
    var body: some View {
        VStack(spacing: AppLayout.searchContentSpacing) {
            Spacer(minLength: AppLayout.smallVerticalSpacing)
            Image("SearchIcon")
                .resizable()
                .scaledToFit()
                .frame(height: height * 0.3)
            
            IndicatorView()
            
            Text("Search for a movie")
                .font(AppFonts.title2)
                .foregroundColor(AppColors.textPrimary)
            
            SearchBar(query: $viewModel.query) {
                Task { await viewModel.search() }
            }
            .frame(minHeight: AppLayout.searchHeight)
        }
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

#Preview {
    SearchView()
}
