//
//  ContentView.swift
//  SearchAppAA
//
//  Created by Maryam on 7/4/25.
//

import SwiftUI

struct SearchView: View {
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                let total = geometry.size.height - geometry.safeAreaInsets.top - geometry.safeAreaInsets.bottom
                let half = (total - AppLayout.searchContentSpacing) / 2
                
                ZStack {
                    VStack(spacing: AppLayout.searchContentSpacing) {
                        
                        TopHalfView(height: half)
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
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct TopHalfView: View {
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
            
            SearchBar()
            .frame(minHeight: AppLayout.searchHeight)
        }
    }
}

struct SearchBar: View {
    var query: String = ""
    
    var body: some View {
        HStack {
            ZStack(alignment: .leading) {
                if query.isEmpty {
                    Text("Search...")
                        .font(AppFonts.title16)
                        .foregroundColor(AppColors.textSecondary)
                }
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
