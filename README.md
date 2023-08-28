<div align="center">

<p>
        <a href="https://discord.gg/8EbwsnaX"><img src="https://img.shields.io/discord/1042743094833065985?color=5865F2&logo=discord&logoColor=white&label=QuickBlox%20Discord%20server&style=for-the-badge" alt="Discord server" /></a>
</p>

</div>
# QBAITranslate

QBAITranslate is a Swift package that provides language management and translation functionalities, including integration with the OpenAI API.

## Installation

QBAITranslate can be installed using Swift Package Manager. To include it in your Xcode project, follow these steps:

1. In Xcode, open your project, and navigate to File > Swift Packages > Add Package Dependency.
2. Enter the repository URL `https://github.com/QuickBlox/ios-ai-translate` and click Next.
3. Choose the appropriate version rule and click Next.
4. Finally, click Finish to add the package to your project.

## Usage

To use QBAITranslate in your project, follow these steps:

1. Import the QBAITranslate module:

```swift
import QBAITranslate
```

2. Set custom language settings and manage translations (English by default):

```swift
// Set a custom language using a Language enum case
QBAITranslate.settings.setCustom(language: .spanish)

// Set a custom language using a Locale object
QBAITranslate.settings.setCustomLanguage(from: Locale(identifier: "es-US"))

// Get the current language
let currentLanguage = QBAITranslate.settings.language

// Reset language settings to default
QBAITranslate.settings.resetLanguage()
```

3. Generate translations using the OpenAI API:

```swift
// Generate a translation using an API key
do {
    let apiKey = "YOUR_OPENAI_API_KEY"
    let translation = try await QBAITranslate.openAI(translate: "Hello", secret: apiKey)
    print("Generated Translation: \(translation)")
} catch {
    print("Error: \(error)")
}

// Generate a translation using a QuickBlox user token and proxy URL
do {
    let qbToken = "YOUR_QUICKBLOX_USER_TOKEN"
    let proxyURL = "https://your-proxy-server-url"
    let translation = try await QBAITranslate.openAI(translate: "Hello", qbToken: qbToken, proxy: proxyURL)
    print("Generated Translation: \(translation)")
} catch {
    print("Error: \(error)")
}
```

## Language Enum

The `Language` enum provides predefined cases for various languages, each associated with a `Locale` object:

```swift
let englishLocale = Language.english.locale
```

## Exception Handling

The `QBAIException` enum represents various exceptions that can be thrown during translation:

- `incorrectToken`: Thrown when the provided token has an incorrect value.
- `incorrectTokensCount`: Thrown when the provided text tokens count has an incorrect value.
- `incorrectProxyServerUrl`: Thrown when the server URL has an incorrect value.

## License

QBAITranslate is released under the [MIT License](LICENSE).

## Contribution

We welcome contributions to improve QBAITranslate. If you find any issues or have suggestions, feel free to open an issue or submit a pull request on GitHub.
Join our Discord Server: https://discord.gg/Yc56F9KG

Happy coding! 🚀
