## 2.0.2

- Fixes macOS build error by marking `.fullScreenCover`s as unavailable

## 2.0.1

- Fixes the initial stack coordinator's index in the `transitionIndices` dictionary

## 2.0.0

- Introduces common `Coordinating` protocol for all type of coordinators
- Adds proper logging
- Introduces `transitionIndices` to fix path inconsistencies in stack-based navigation
- Fixes the `popToInitialRoute()` on the initial coordinator 

## 1.0.0

- Coordination of `TabView`s
- Coordination of `NavigationStack`s
- Coordination of modal `View`s like `.sheet`s & `.fullScreenCover`s
- URL-based deep linking
- Validity-checking for deep link URLs 
