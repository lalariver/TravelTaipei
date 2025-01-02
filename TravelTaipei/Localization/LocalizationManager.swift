//
//  LocalizationManager.swift
//  TravelTaipei
//
//  Created by user on 2024/12/30.
//

import Foundation

// Enum 定義語系
enum Language: String, CaseIterable {
    case tw = "zh-tw"
    case cn = "zh-cn"
    case en
    case ja
    case ko
    case es
    case id
    case th
    case vi
    
    var displayName: String {
        switch self {
        case .tw:
            return "正體中文"
        case .cn:
            return "简体中文"
        case .en:
            return "English"
        case .ja:
            return "日本語"
        case .ko:
            return "한국어"
        case .es:
            return "Español"
        case .id:
            return "Bahasa Indonesia"
        case .th:
            return "ภาษาไทย"
        case .vi:
            return "Tiếng Việt"
        }
    }
    
    var languageCode: String {
        switch self {
        case .tw:
            return "zh-Hant"  // 繁體中文（台灣）
        case .cn:
            return "zh-Hans"  // 簡體中文（中國）
        case .en:
            return "en"       // 英文
        case .ja:
            return "ja"       // 日文
        case .ko:
            return "ko"       // 韓文
        case .es:
            return "es"       // 西班牙文
        case .id:
            return "id"       // 印尼文
        case .th:
            return "th"       // 泰文
        case .vi:
            return "vi"       // 越南文
        }
    }
}

final class LocalizationManager {
    static let shared = LocalizationManager()
    private let defaults = UserDefaults.standard
    
    private let appleLanguageKey = "AppleLanguages"
    
    private init() {
        defaults.set(["zh-tw"], forKey: appleLanguageKey)
        defaults.synchronize()
    }
    
    // 現在的語系（預設為英文）
    private var currentLanguage: Language {
        let languages = defaults.object(forKey: appleLanguageKey) as? [String]
        let lang = languages?.first ?? "zh-tw"
        return Language(rawValue: lang) ?? .tw
    }
    
    // 取得現在語系的顯示名稱
    public func getCurrentLanguageName() -> String {
        return currentLanguage.displayName
    }
    
    public func getCurrentLangCode() -> String {
        return currentLanguage.rawValue
    }
    
    public func getCurrentLang() -> Language {
        return currentLanguage
    }
    
    // 切換語系
    public func setLanguage(_ languageCode: String) {
        defaults.set([languageCode], forKey: appleLanguageKey)
        defaults.synchronize()
    }
}
