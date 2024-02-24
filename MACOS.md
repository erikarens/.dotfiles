# How i configured MacOS for an optimal workflow
## System Behavior
### General stuff
* Turn Off: `System Settings -> Dektop & Dock -> Mission Control / Automatically rearrange Spaces based on most recent use`
* Turn On: `System Settings -> Accessibility -> Display -> Reduce motion`
* Turn on shortcuts to switch desktops with `control + number`: `Keyboard -> Keyboard Shortcuts -> Mission Control -> Misson Control -> Switch to Desktop ...`
* Change to `Fast`: `System Settings -> Keyboard -> Key repeat rate -> Fast`
* Change to `Short`: `System Settings -> Keyboard -> Delay until repeat -> Short`

### Dock Settings
* Magnification: `Off`
* Size: About `1/4th`
* Position: `Left`
* Automatically hide and show the Dock: `True`
* Animate opening applications: `false`
* Show suggested and recent apps in Dock: `false`

### Vim-Motion on MacOS but preserve the accent context menu behavior when long pressing umlauts
First we need to clarify the meaning of `ApplePressAndHoldEnabled`, if it's true (default value) it corresponde to the following settings:
* `show-character-accents-menu` = `true`
* `repeat-character-while-key-held` = `false`

But what we want to arive is that we disable it globally but only enable it in certain programms.

> How to set `show-character-accents-menu` behaviour globally by default, but `repeat-character-while-key-held` behaviour per-application

1. The `ApplePressAndHoldEnabled` `default` must be **unset** globally (rather than being set to `true` o `false`), with the following command
    ```Bash
    defaults delete -g ApplePressAndHoldEnabled    # Unset globally
    ```
2. The `ApplePressAndHoldEnabled` default must be **set** to `false` for each application for which you wish to set the `repeat-character-while-key-held` behaviour, with the following command:
    ```Bash
    defaults write "$APP_ID" ApplePressAndHoldEnabled -bool false
    ```
    Where `$APP_ID` is something like `com.jetbrains.rider` for "JetBrains Rider" or `com.microsoft.VSCode` for "Visual Studio Code".

    In our situation i want to do this for JetBrains Rider and VSCode
    ```Bash
    defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false              # For VS Code
    defaults write com.microsoft.VSCodeInsiders ApplePressAndHoldEnabled -bool false      # For VS Code Insider
    defaults write com.vscodium ApplePressAndHoldEnabled -bool false                      # For VS Codium
    defaults write com.microsoft.VSCodeExploration ApplePressAndHoldEnabled -bool false   # For VS Codium Exploration users
    defaults write com.jetbrains.rider ApplePressAndHoldEnabled -bool false               # For JetBrains Rider users
    defaults delete -g ApplePressAndHoldEnabled                                           # If necessary, reset global default
    ```
3. Paste this code in the terminal to set the `repeat-character-while-key-held` behaviour for all JetBrains IDE's and for VSCode, but set `show-character-accents-menu` behviour globally:
    
    For JetBrains IDE's:
    ```Bash
    KEY='ApplePressAndHoldEnabled' \
    && defaults delete -g "$KEY" \
    ; echo \
    && APP_ID_PREFIX='com\.jetbrains\.' \
    && defaults read | egrep -o "${APP_ID_PREFIX}[^\"]+" | sort --unique \
    | while read APP_ID; do
        echo "Setting \"repeat-character-while-key-held\" for application: '$APP_ID'..."
        defaults write "$APP_ID" "$KEY" -bool 'false'
    done
    ```

    For VSCode:
    ```Bash
    KEY='ApplePressAndHoldEnabled' \
    && defaults delete -g "$KEY" \
    ; echo \
    && APP_ID_PREFIX='com\.microsoft\.VSCode' \
    && defaults read | egrep -o "${APP_ID_PREFIX}[^\"]+" | sort --unique \
    | while read APP_ID; do
        echo "Setting \"repeat-character-while-key-held\" for application: '$APP_ID'..."
        defaults write "$APP_ID" "$KEY" -bool 'false'
    done
    ```
## Window Management

For Window-Management i currenlty use `Moom` and `rmcd`, but i want to try `Yabai` with some nice shortcuts made with `Skhd` in the future. Something like this -> https://www.youtube.com/watch?v=k94qImbFKWE&ab_channel=JoseanMartinez