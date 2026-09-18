pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell

Singleton {
    id: root
    property var notifications: []
    property var queue: []
    property int maxNotification: 20
    property var current: null
    readonly property bool active: current !== null
    property int displayTime: 1000

    function enqueue(notification): void {
        notification.closed.connect(() => root.remove(notification));

        if (!notification.transient) {
            notifications = [notification].concat(notifications.filter(item => item !== notification));

            while (notifications.length > maxNotification) {
                const old = notifications[notifications.length - 1];
                notifications = notifications.slice(0, -1);
                queue = queue.filter(item => item !== old);
                old.dismiss();
            }
        }

        queue = queue.concat([notification]);
        if (!current) {
            advance();
        }
    }

    function advance(): void {
        const previous = current;
        current = null;

        if (previous && previous.transient && previous.tracked) {
            previous.expire();
        }

        while (queue.length > 0 && !queue[0].tracked) {
            queue = queue.slice(1);
        }

        if (queue.length === 0) {
            hideTimer.stop();
            if (IslandManager.currentMode === IslandManager.NotificationPopup) {
                IslandManager.close();
            }
            return;
        }

        current = queue[0];
        queue = queue.slice(1);
        hideTimer.restart();
        IslandManager.showNotificationPopup();
    }

    function remove(notification): void {
        const wasCurrent = current === notification;

        notifications = notifications.filter(item => item !== notification);
        queue = queue.filter(item => item !== notification);

        if (wasCurrent) {
            current = null;
            hideTimer.stop();

            if (IslandManager.currentMode === IslandManager.NotificationPopup) {
                advance();
            }
        }
    }

    function dismiss(notification): void {
        remove(notification);
        if (notification.tracked) {
            notification.dismiss();
        }
    }

    function clearAll(): void {
        const discarded = notifications.slice();

        notifications = [];
        queue = queue.filter(item => !discarded.includes(item));

        if (discarded.includes(current)) {
            current = null;
            hideTimer.stop();
        }

        for (const notification of discarded) {
            if (notification.tracked) {
                notification.dismiss();
            }
        }
    }

    Timer {
        id: hideTimer
        interval: root.displayTime
        onTriggered: root.advance()
    }
}
