# DALL・E 2 API Images

## iOS OpenAI Image Generator App Experiment

This is an **experimental iOS App** that make use of the **OpenAI API** to generate images.
The app allows the user to generate an image from a description.

## Getting Started

### Prerequisites
- A valid OpenAI API key
- Xcode 14.0 or later
- A simulator running iOS 16.0 or later

### Installation
1. Clone the repository and open it in Xcode.
2. Create a new plist file called OpenAI-Info.plist.
3. Add a new key/value pair to OpenAI-Info.plist (chose `API_KEY` for the name of the key).[^1]
4. Generate an OpenAI API key and add it to the project as a `String` type in the `Value` field of the newly created plist file.  
5. Build and run the app.

[^1]: [Fetching API Keys from Property List Files](https://peterfriese.dev/posts/reading-api-keys-from-plist-files/).

## Limitations

- Images are limited to 1024x1024 pixels due to OpenAI API constraints.
- Real-time geenration using DALL·E 2 API is still far from perfect, so please use it with some expectations.
- Free trial of OpenAI APIs includes 3 months of usage and $18.00.

## Disclaimer

- This is an experimental app and should be used with caution.
- OpenAI provides no dependencies or guarantees regarding the accuracy or reliability of the results generated by the API.
- All code here is released under the MIT license, which permits commercial use, modification, distribution, and private use.


