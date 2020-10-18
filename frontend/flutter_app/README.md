# Text Summary App
Front end app

<img src="https://github.com/LoriSchuan-dev/SoftAIP2_YourNote/blob/master/frontend/flutter_app/assets/1.png" width="340" height="700">
<img src="https://github.com/LoriSchuan-dev/SoftAIP2_YourNote/blob/master/frontend/flutter_app/assets/3.gif" width="340" height="700">
### Getting Started

#### Prerequisites
* [Flutter](https://flutter.dev) - Google Flutter framework.
* [Android Studio](https://developer.android.com/studio) or [VSCode](https://code.visualstudio.com/)
#### Installing
* [How to install](https://flutter.dev/docs/get-started/install)
#### Cloning a repository:
1. On GitHub, navigate to the main page of the repository.
2. Under the repository name, click `Clone or download`.
3. In the `Clone with HTTPs` section, click  to copy the clone URL for the repository.
4. Open Terminal.
5. Change the current working directory to the location where you want the cloned directory to be made.
6. Type git clone, and then paste the URL you copied in Step 2.
7. Press Enter. Your local clone will be created.
#### Running:
1. Open the project in Android Studio or Visual Studio Code.
2. Get Google speech API key and create:

    `google_key.json`

    Also replace the URL `http://sonchau.pythonanywhere.com/summarizer/api/v1.0/summarize` with your own backend.

3. From the terminal: Run `flutter pub get`

   OR From Android Studio/IntelliJ: Click Packages get in the action ribbon at the top of pubspec.yaml

   OR From VS Code: Click Get Packages located in right side of the action ribbon at the top of pubspec.yaml.

   [Full instruction can be found here](https://flutter.dev/docs/development/packages-and-plugins/using-packages)

5. Open Android simular or iOS simulator or connect device to the computer.
6. Hit Run button

### Build testing:
##### iOS:
1. Open the terminal and navigate to this folder, enter `flutter build ios`
2. Use xcode and open ios/Runner folder then start the app
3. [You can view the full instructions here](https://flutter.dev/docs/deployment/ios)

##### Android:
1. Connect device through USB, enable developer option and file transfer
2. Open Android Studio, select device on the run target and click Run
3. [You can view the full instructions here](https://flutter.dev/docs/deployment/android)




