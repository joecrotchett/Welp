//
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: Properties

    var window: UIWindow?

    // MARK: Lifecycle

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        StyleGuide.apply(to: window!)

        let splitViewController = WelpSplitViewController(style: .doubleColumn)
        window?.rootViewController = splitViewController
        window?.makeKeyAndVisible()

        return true
    }
}
