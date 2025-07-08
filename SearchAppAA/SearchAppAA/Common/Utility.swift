//
//  Utility.swift
//  SearchAppAA
//
//  Created by Maryam on 7/8/25.
//

import Foundation

enum Config {
    static var appAPIKey: String {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "AppAPIKey") as? String, !key.isEmpty else {
            fatalError("AppAPIKey in plist is missing")
        }
        return key
    }
}
