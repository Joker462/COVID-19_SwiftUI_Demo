# COVID-19_SwiftUI_Demo

## About

`COVID-19_SwiftUI_Demo` is the coronavirus information application using [SwiftUI](https://developer.apple.com/xcode/swiftui) which is first introduced in WWDC19 keynote. 

The application using [ChartView](https://github.com/AppPear/ChartView) to display the currently cases and more stuff about COVID-19.

This APIs project park a fork from [NovelCODVID](https://github.com/NovelCOVID/API) and [NewsAPI](https://newsapi.org/)

## Requirements
* iOS 13 and Xcode 11
* Please sign up and request to get your api key from [NewsAPI](https://newsapi.org/)
* Add your api key from `NewsAPI` to the `NEWSAPIKEY` property of the `CovidEndPoint.swift` file.

* If you get the SwiftUICharts dependency error, you remove the  ChartView package from the Swift Packages of the project

![screenshot](https://github.com/Joker462/COVID-19_SwiftUI_Demo/blob/master/error.png)

* In Xcode got to File -> Swift Packages -> Add Package Dependency and paste in the repo's url: https://github.com/AppPear/ChartView

## Demo

![screenshots](https://github.com/Joker462/COVID-19_SwiftUI_Demo/blob/master/example.png)

## License

The MIT License (MIT)

Copyright (c) 2020 Hung Thai (hungthai270893@gmail.com)
