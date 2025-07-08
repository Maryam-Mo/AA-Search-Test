//
//  IndicatorView.swift
//  SearchAppAA
//
//  Created by Maryam on 7/8/25.
//

import SwiftUI

struct IndicatorView: View {
    var body: some View {
        HStack(spacing: AppLayout.indicatorSpacing) {
            Capsule().fill(AppColors.indicatorActive).frame(width: AppLayout.indicatorActiveWidth, height: AppLayout.indicatorHeight)
            Capsule().fill(AppColors.indicatorInactive).frame(width: AppLayout.indicatorInactiveWidth, height: AppLayout.indicatorHeight)
            Capsule().fill(AppColors.indicatorInactive).frame(width: AppLayout.indicatorInactiveWidth, height: AppLayout.indicatorHeight)
        }
    }
}
