pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell.Hyprland

QtObject {

    enum Mode {
        Normal,
        AppLauncher,
        PowerMenu,
        Confirmation,
        NotificationPopup,
        ControlCenter,
        CommandPalette
    }

    property list<int> focusList: [IslandManager.AppLauncher, IslandManager.PowerMenu, IslandManager.Confirmation, IslandManager.ControlCenter, IslandManager.CommandPalette]

    property int currentMode: IslandManager.Normal
    property string confirmationMessage: ""
    property var confirmationAction: null

    property var previousTopLevel: null

    function rememberFocus() {
        if (Hyprland.activeToplevel) {
            previousTopLevel = Hyprland.activeToplevel;
        }
    }

    function restoreFocus() {
        if (previousTopLevel) {
            previousTopLevel.wayland.activate();
            previousTopLevel = null;
        }
    }

    function showNormal() {
        currentMode = IslandManager.Normal;
    }

    function showAppLauncher() {
        openMode(IslandManager.AppLauncher);
    }

    function showPowerMenu() {
        openMode(IslandManager.PowerMenu);
    }

    function showConfirmation(message, action) {
        confirmationMessage = message;
        confirmationAction = action;
        openMode(IslandManager.Confirmation);
    }

    function acceptConfirmation() {
        var action = confirmationAction;
        clearConfirmation();
        close();

        if (typeof action === "function") {
            action();
        }
    }

    function rejectConfirmation() {
        clearConfirmation();
        close();
    }

    function clearConfirmation() {
        confirmationMessage = "";
        confirmationAction = null;
    }

    function showNotificationPopup() {
        currentMode = IslandManager.NotificationPopup;
    }

    function showControlCenter() {
        openMode(IslandManager.ControlCenter);
    }

    function openMode(mode) {
        if (shouldFocus(mode) && !shouldFocus(currentMode)) {
            rememberFocus();
        }

        currentMode = mode;
    }

    function toggleMode(mode) {
        if (currentMode === mode) {
            close();
        } else {
            openMode(mode);
        }
    }

    function shouldFocus(mode) {
        if (mode === undefined) {
            mode = currentMode;
        }
        return focusList.includes(mode);
    }

    function close() {
        currentMode = IslandManager.Normal;

        Qt.callLater(() => {
            restoreFocus();
        });
    }

    function isActive(mode) {
        return mode === currentMode;
    }

    function canShowMode(screen, mode) {
        return modeForScreen(screen) === mode;
    }

    function modeForScreen(screen) {
        var oneMonitorModes = [IslandManager.AppLauncher, IslandManager.PowerMenu, IslandManager.Confirmation, IslandManager.NotificationPopup, IslandManager.ControlCenter, IslandManager.CommandPalette];
        if (oneMonitorModes.includes(currentMode) && !MonitorManager.isFocus(screen)) {
            return IslandManager.Normal;
        }
        return currentMode;
    }
}
