<div align="center">

<p>
        <a href="https://discord.gg/bDyKXGAQRu"><img src="https://img.shields.io/discord/1042743094833065985?color=5865F2&logo=discord&logoColor=white&label=QuickBlox%20Discord%20server&style=for-the-badge" alt="Discord server" /></a>
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

2. Generate translations using the OpenAI API:

```swift
let text: String = ... // Replace this with the text you want to translate

// Optionally, you can provide a history of previous messages to aid in translation. 
// let message1 = AIMessage(role: .me, text: "Hello! I’m Dr Sheridan. How can I help?")
// let message2 = AIMessage(role: .other, text: "Estoy visitando desde España y he perdido mis medicamentos recetados. ¿Puede ayudarme a conseguir más antibióticos?")
// let messages = [message1, message2]

// Generate a translation using an API key
do {
    let settings = AISettings(apiKey: "YOUR_OPENAI_API_KEY", language: .english)
    let translation = try await QBAITranslate.translate(text: text, history: messages, using: settings)
    print("Generated Translation: \(translation)")
} catch {
    print("Error: \(error)")
}

// Generate a translation using a QuickBlox user token and proxy URL
do {
    let qbToken = "YOUR_QUICKBLOX_USER_TOKEN"
    let proxyURL = "https://your-proxy-server-url"
    let settings = AISettings(token: qbToken, serverPath: proxyURL, language: .english)
    let translation = try await QBAITranslate.translate(text: text, history: messages, using: settings)
    print("Generated Translation: \(translation)")
} catch {
    print("Error: \(error)")
}
```

## OpenAI

To use the OpenAI API and generate answers, you need to obtain an API key from OpenAI. Follow these steps to get your API key:

1. Go to the [OpenAI website](https://openai.com) and sign in to your account or create a new one.
2. Navigate to the [API](https://platform.openai.com/signup) section and sign up for access to the API.
3. Once approved, you will receive your [API key](https://platform.openai.com/account/api-keys), which you can use to make requests to the OpenAI API.

## Proxy Server

Using a proxy server like the [QuickBlox AI Assistant Proxy Server](https://github.com/QuickBlox/qb-ai-assistant-proxy-server) offers significant benefits in terms of security and functionality:

Enhanced Security:
- When making direct requests to the OpenAI API from the client-side, sensitive information like API keys may be exposed. By using a proxy server, the API keys are securely stored on the server-side, reducing the risk of unauthorized access or potential breaches.
- The proxy server can implement access control mechanisms, ensuring that only authenticated and authorized users with valid QuickBlox user tokens can access the OpenAI API. This adds an extra layer of security to the communication.

Protection of API Keys:
- Exposing API keys on the client-side could lead to misuse, abuse, or accidental exposure. A proxy server hides these keys from the client, mitigating the risk of API key exposure.
- Even if an attacker gains access to the client-side code, they cannot directly obtain the API keys, as they are kept confidential on the server.

Rate Limiting and Throttling:
- The proxy server can enforce rate limiting and throttling to control the number of requests made to the OpenAI API. This helps in complying with API usage policies and prevents excessive usage that might lead to temporary or permanent suspension of API access.

Request Logging and Monitoring:
- By using a proxy server, requests to the OpenAI API can be logged and monitored for auditing and debugging purposes. This provides insights into API usage patterns and helps detect any suspicious activities.

Flexibility and Customization:
- The proxy server acts as an intermediary, allowing developers to introduce custom functionalities, such as response caching, request modification, or adding custom headers. These customizations can be implemented without affecting the client-side code.

SSL/TLS Encryption:
- The proxy server can enforce SSL/TLS encryption for data transmission between the client and the server. This ensures that data remains encrypted and secure during communication.

## Language Enum

The `Language` enum provides predefined cases for various languages, each associated with a `Locale` object:

```swift
let englishLocale = Language.english.locale
```

## License

QBAITranslate is released under the [MIT License](LICENSE).

## Contribution

We welcome contributions to improve QBAITranslate. If you find any issues or have suggestions, feel free to open an issue or submit a pull request on GitHub.
Join our Discord Server: https://discord.gg/bDyKXGAQRu

Happy coding! 🚀
