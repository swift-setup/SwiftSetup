# Create variable name for the app name
APP_NAME="SwiftSetup"

# create dmg
create-dmg $APP_NAME.app
CP *.dmg $APP_NAME.dmg

# notarize the app
xcrun notarytool submit $APP_NAME.dmg --apple-id "$APPLE_ID" --team-id "$APPLE_TEAM_ID" --password "$APPLE_ID_PWD"