import Foundation

protocol NotificationsService {
    func start()
}

class NotificationsServiceImpl: NotificationsService {
    @Inject private var onScreen: OnScreenCoordinator
    
    func start() {
        DistributedNotificationCenter.default().addObserver(
            self,
            selector: #selector(onGotNotification(_:)),
            name: NSNotification.Name("it.curzel.pets.Api"),
            object: nil
        )
    }
    
    @objc private func onGotNotification(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        handleNotification(payload: userInfo)
    }
    
    private func handleNotification(payload: [AnyHashable: Any]) {
        guard let subject = payload["subject"] as? String else { return }
        guard let action = payload["action"] as? String else { return }
        let point = point(from: payload)
        onScreen.animate(petId: subject, actionId: action, position: point)
    }
    
    private func point(from payload: [AnyHashable: Any]) -> CGPoint? {
        guard let x = payload["x"] as? CGFloat else { return nil }
        guard let y = payload["y"] as? CGFloat else { return nil }
        return CGPoint(x: x, y: y)
    }
}
