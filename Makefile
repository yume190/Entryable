.PHONY = podUpdate
podUpdate:
	pod trunk push YumeAlamofire.podspec

.PHONY = podLint
podLint:
	pod lib lint YumeAlamofire.podspec --allow-warnings

.PHONY = carthage
carthage: 
	carthage build \
		--no-skip-current \
		--platform ios \
		--configuration ReleaseFramework \
		YumeAlamofire JSONMock
	test -d Carthage/Build/iOS/YumeAlamofire.framework
	test -d Carthage/Build/iOS/JSONMock.framework

.PHONY = pod
pod: podLint

.PHONY = spm
spm: 
	swift test

# xcode:
# - RELEASE=Debug
#   - SCHEME=YumeAlamofire
#   - SDK=iphonesimulator
#       DESTINATION='platform=iOS Simulator,OS=11.3,name=iPhone X'
# 	xcodebuild \
# 		-project JSONDecodeKit.xcodeproj \
# 		-scheme $SCHEME \
# 		-configuration $RELEASE \
# 		-sdk $SDK \
# 		-destination "$DESTINATION" \
# 		clean build test