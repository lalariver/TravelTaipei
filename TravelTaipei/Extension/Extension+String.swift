//
//  Extension+String.swift
//  TravelTaipei
//
//  Created by user on 2024/12/31.
//

import Foundation

extension String {
    var localized: String {
        guard let bundlePath = Bundle.main.path(forResource: LocalizationManager.shared.getCurrentLang().languageCode, ofType: "lproj"),
              let bundle = Bundle(path: bundlePath)
        else {
            return NSLocalizedString(self, comment: "")
        }
        return NSLocalizedString(self, tableName: nil, bundle: bundle, comment: "")
    }
}
