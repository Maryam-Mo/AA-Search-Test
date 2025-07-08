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
                
                ScrollView {
                    VStack(alignment: .leading, spacing: AppLayout.searchContentSpacing) {
                        DetailSection(heading: "Overview",content: movie.overview ?? "No overview available.")
                        
                        if let date = movie.releaseDate {
                            DetailSection(heading: "Release Date", content: date)
                        }
                                                
                        StatisticsSection(movie: movie)
                    }
                }
                .frame(maxHeight: .infinity)

                BottomButton(title: "Back") {
                    dismiss()
                }
                .padding(.bottom, AppLayout.defaultPadding)
            }
            .ignoresSafeArea(.keyboard)
            .padding(.horizontal, AppLayout.defaultPadding)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                        Text("BACK")
                            .font(AppFonts.subheadline)
                    }
                    .foregroundColor(.white)
                }
            }
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


private struct DetailSection: View {
    let heading: String
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppLayout.searchContentSpacing) {
            Text(heading)
                .font(AppFonts.title16)
                .foregroundColor(.white)
            
            Text(content)
                .font(AppFonts.subheadline)
                .foregroundColor(AppColors.bodySecondary)
        }
    }
}


private struct StatisticsSection: View {
    let movie: Movie
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppLayout.searchContentSpacing) {
            Text("Statistics")
                .font(AppFonts.title16)
                .foregroundColor(AppColors.textPrimary)
            
            statisticsRow(label: "Popularity", value: movie.popularity.map { String(format: "%.1f", $0) } ?? "N/A")
            Divider().background(AppColors.dividerColor)
            
            statisticsRow(label: "Rating", value: movie.voteAverage.map { String(format: "%.1f", $0) } ?? "N/A")
            Divider().background(AppColors.dividerColor)
            
            statisticsRow(label: "Votes", value: movie.voteCount.map { String($0) } ?? "N/A")
            Divider().background(AppColors.dividerColor)
        }
    }
    
    private func statisticsRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(AppFonts.subheadline)
                .foregroundColor(AppColors.textPrimary)
            Spacer()
            Text(value)
                .font(AppFonts.caption)
                .foregroundColor(AppColors.textSecondary)
        }
    }
}

private struct BottomButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(AppFonts.title16)
                .frame(maxWidth: .infinity)
                .padding()
                .background(AppColors.backButtonColor)
                .clipShape(Capsule())
                .foregroundColor(AppColors.textPrimary)
                .accessibilityIdentifier("detailBackButton")
        }
    }
}


#Preview {
    NavigationStack {
        DetailView(
            movie: Movie(
                id: 1,
                title: "Preview Movie",
                overview: "This is a preview overview of the movie. It’ll wrap and display nicely in multiple lines.",
                releaseDate: "2025-07-06",
                popularity: 87.5,
                voteAverage: 7.8,
                voteCount: 1234
            )
        )
    }
}
