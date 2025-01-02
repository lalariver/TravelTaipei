//
//  Extension+UIAlertController.swift
//  TravelTaipei
//
//  Created by user on 2024/12/31.
//

import Foundation
import UIKit

enum OpenOption {
    case `internal`
    case external
}

extension UIAlertController {
    static func createLanguageSelectionMenu(handler: @escaping () -> Void) -> UIAlertController {
        let alertController = UIAlertController(title: "選擇語言".localized, message: nil, preferredStyle: .actionSheet)
        let currentLanguage = LocalizationManager.shared.getCurrentLanguageName()
        
        for language in Language.allCases {
            let isCurrent = (language.displayName == currentLanguage)
            let action = UIAlertAction(
                title: isCurrent ? "\(language.displayName) ✅" : language.displayName,
                style: .default
            ) { _ in
                LocalizationManager.shared.setLanguage(language.rawValue)
                handler()
            }
            alertController.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: "取消".localized, style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        return alertController
    }
    
    static func displayURLSelectionAlert(handler: @escaping (OpenOption) -> Void) -> UIAlertController {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "App 內部開啟".localized, style: .default) { _ in
            handler(.internal)
        })
        
        alert.addAction(UIAlertAction(title: "手機瀏覽器開啟".localized, style: .default) { _ in
            handler(.external)
        })
        
        let cancelAction = UIAlertAction(title: "取消".localized, style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        return alert
    }
}
