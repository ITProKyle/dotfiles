#!/usr/bin/env bash
# https://github.com/mathiasbynens/dotfiles/blob/main/.macos

# Disabled temporarily

# set -eufo pipefail  # cspell:ignore eufo

# # Close any open System Preferences panes, to prevent them from overriding
# # settings we’re about to change
# osascript -e 'tell application "System Preferences" to quit'


# ###############################################################################
# # Dock & Dashboard                                                            #
# ###############################################################################
# defaults write com.apple.dashboard mcx-disabled -bool true
# defaults write com.apple.dock autohide -bool true
# defaults write com.apple.dock dashboard-in-overlay -bool true
# defaults write com.apple.dock enable-spring-load-actions-on-all-items -bool true
# defaults write com.apple.dock expose-animation-duration -float 0.1
# defaults write com.apple.dock largesize -int 94
# defaults write com.apple.dock launchanim -bool false
# defaults write com.apple.dock magnification -bool true
# defaults write com.apple.dock mineffect -string "scale"
# defaults write com.apple.dock minimize-to-application -bool true
# defaults write com.apple.dock mru-spaces -bool false
# defaults write com.apple.dock show-process-indicators -bool true


# ###############################################################################
# # Finder                                                                      #
# ###############################################################################
# defaults write NSGlobalDomain AppleShowAllExtensions -bool true  # show all filename extensions
# defaults write com.apple.finder AppleShowAllFiles -bool true  # show hidden files by default
# defaults write com.apple.finder DisableAllAnimations -bool true
# defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"  # search the current folder by default
# defaults write com.apple.finder NewWindowTarget -string "PfHe"  # set the default location for new windows
# defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}"
# defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
# defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
# defaults write com.apple.finder ShowMountedServersOnDesktop -bool false
# defaults write com.apple.finder ShowPathbar -bool true
# defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true
# defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
# defaults write com.apple.finder _FXSortFoldersFirst -bool true  # keep folders on top when sorting by name


# ###############################################################################
# # General UI/UX                                                               #
# ###############################################################################
# defaults write NSGlobalDomain AppleAccentColor -int 5
# defaults write NSGlobalDomain AppleHighlightColor -string "0.968627 0.831373 1.000000"  # set highlight color to purple
# defaults write NSGlobalDomain AppleInterfaceStyle Dark
# defaults write NSGlobalDomain AppleLanguages -array en-US
# defaults write NSGlobalDomain AppleLocale en_US
# defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false  # disable automatic capitalization
# defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false  # disable smart dashes
# defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false  # disable automatic period substitution
# defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false  # disable smart quotes
# defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false  # disable auto-correct
# defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true  # expand print panel by default
# defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true  # expand print panel by default
# defaults write NSGlobalDomain WebAutomaticSpellingCorrectionEnabled -bool false
# defaults write NSGlobalDomain com.apple.sound.beep.flash -bool false
# defaults write NSGlobalDomain com.apple.springing.delay -float 0.5  # spring loading delay for directories
# defaults write NSGlobalDomain com.apple.springing.enabled -bool true  # enable spring loading for directories
# defaults write NSGlobalDomain com.apple.trackpad.forceClick -bool true
# defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
# defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"  # use list view by default: icnv, clmv, glyv, Nlsv
# defaults write com.apple.finder WarnOnEmptyTrash -bool false

# defaults write com.apple.finder FXInfoPanesExpanded -dict \
#   Comments -bool true \
#   General -bool true \
#   MetaData -bool true \
#   Name -bool true \
#   OpenWith -bool true \
#   Preview -bool false \
#   Privileges -bool true

# # Enable snap-to-grid for icons on the desktop and in other icon views
# /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
# /usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
# /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist

# # Show the ~/Library folder
# chflags nohidden ~/Library
# xattr -d com.apple.FinderInfo ~/Library &>/dev/null || true

# # Show the /Volumes folder
# # sudo chflags nohidden /Volumes


# ###############################################################################
# # Google Chrome & Google Chrome Canary                                        #
# ###############################################################################
# # disable the all too sensitive backswipe on trackpads
# defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool false
# defaults write com.google.Chrome.canary AppleEnableSwipeNavigateWithScrolls -bool false

# # disable the all too sensitive backswipe on Magic Mouse
# defaults write com.google.Chrome AppleEnableMouseSwipeNavigateWithScrolls -bool false
# defaults write com.google.Chrome.canary AppleEnableMouseSwipeNavigateWithScrolls -bool false

# # expand the print dialog by default
# defaults write com.google.Chrome PMPrintingExpandedStateForPrint2 -bool true
# defaults write com.google.Chrome.canary PMPrintingExpandedStateForPrint2 -bool true


# ###############################################################################
# # Trackpad, mouse, keyboard, Bluetooth accessories, and input                 #
# ###############################################################################
# # increase sound quality for Bluetooth headphones/headsets
# defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40
# defaults write NSGlobalDomain InitialKeyRepeat -int 15
# defaults write NSGlobalDomain KeyRepeat -int 2


# ###############################################################################
# # Kill affected applications                                                  #
# ###############################################################################
# for app in \
# 	"Dock" \
# 	"Finder" \
# 	"SystemUIServer"; do
# 	killall "${app}" &> /dev/null
# done


# ###############################################################################
# # Set default applications                                                    #
# ###############################################################################
# duti "${HOME}/.config/duti/defaults.duti"


# ###############################################################################
# # Finishing up                                                                #
# ###############################################################################
# echo "Done. Note that some of these changes require a logout/restart to take effect."
