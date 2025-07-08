//
//  DetailView.swift
//  SearchAppAA
//
//  Created by Maryam on 7/8/25.
//

import SwiftUI

struct DetailView: View {
    @Environment(\.dismiss) private var dismiss
    let movie: Movie
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: AppLayout.searchContentSpacing) {
                HeaderSection(title: movie.title)
            }
            .ignoresSafeArea(.keyboard)
            .padding(.horizontal, AppLayout.defaultPadding)
        }
    }
}

private struct TitleView: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(AppFonts.title2)
            .foregroundColor(AppColors.textPrimary)
            .multilineTextAlignment(.center)
    }
}

private struct HeaderSection: View {
    let title: String

    var body: some View {
        VStack(spacing: 20) {
            IndicatorView()
            TitleView(title: title)
        }
        .padding(.top, AppLayout.defaultPadding)
    }
}
