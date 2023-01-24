# Create variable name for the app name
APP_NAME="SwiftSetup"

zip -r $APP_NAME.zip $APP_NAME.app
# copy the archive to root
cp release.xcarchive/Products/Applications/$APP_NAME.zip .

# notarize the app
xcrun notarytool submit $APP_NAME.zip --apple-id "$APPLE_ID" --team-id "$APPLE_TEAM_ID" --password "$APPLE_ID_PWD"