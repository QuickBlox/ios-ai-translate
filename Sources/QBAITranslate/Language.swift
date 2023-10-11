//
//  QBAITranslate.swift
//
//  Created by Injoit on 22.09.2023.
//  Copyright © 2023 QuickBlox. All rights reserved.
//

import Foundation

public enum Language: String, CaseIterable {
    case english = "en"
    case spanish = "es"
    case chineseSimplified = "zh-Hans"
    case chineseTraditional = "zh-Hant"
    case french = "fr"
    case german = "de"
    case japanese = "ja"
    case korean = "ko"
    case italian = "it"
    case russian = "ru"
    case portuguese = "pt"
    case arabic = "ar"
    case hindi = "hi"
    case turkish = "tr"
    case dutch = "nl"
    case polish = "pl"
    case ukrainian = "uk"
    case albanian = "sq"
    case armenian = "hy"
    case azerbaijani = "az"
    case basque = "eu"
    case belarusian = "be"
    case bengali = "bn"
    case bosnian = "bs"
    case bulgarian = "bg"
    case catalan = "ca"
    case croatian = "hr"
    case czech = "cs"
    case danish = "da"
    case estonian = "et"
    case finnish = "fi"
    case galician = "gl"
    case georgian = "ka"
    case greek = "el"
    case gujarati = "gu"
    case hungarian = "hu"
    case indonesian = "id"
    case irish = "ga"
    case kannada = "kn"
    case kazakh = "kk"
    case latvian = "lv"
    case lithuanian = "lt"
    case macedonian = "mk"
    case malay = "ms"
    case maltese = "mt"
    case mongolian = "mn"
    case nepali = "ne"
    case norwegian = "no"
    case pashto = "ps"
    case persian = "fa"
    case punjabi = "pa"
    case romanian = "ro"
    case sanskrit = "sa"
    case serbian = "sr"
    case sindhi = "sd"
    case sinhala = "si"
    case slovak = "sk"
    case slovenian = "sl"
    case urdu = "ur"
    case uzbek = "uz"
    case vietnamese = "vi"
    case welsh = "cy"
    
    /// Returns the `Locale` associated with the language.
    public var locale: Locale {
        return Locale(identifier: rawValue)
    }
}

public extension Locale {
    static var defaultLocalizedLanguageName = "English"
    
    /// Returns the localized language name for the locale.
    var localizedLanguageName: String {
        guard let code = self.languageCode else {
            return Locale.defaultLocalizedLanguageName
        }
        
        let english = QBAITranslate.Language.english
        return english.locale.localizedString(forLanguageCode: code)
        ?? Locale.defaultLocalizedLanguageName
    }
}
