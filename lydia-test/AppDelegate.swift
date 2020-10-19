//
//  AppDelegate.swift
//  lydia-test
//
//  Created by Benoît Durand on 14/10/2020.
//

import UIKit
import CoreData
import SnapKit
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var rootController: UINavigationController { return self.window!.rootViewController as! UINavigationController }
    private lazy var applicationCoordinator: Coordinator = self.makeCoordinator()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        #if DEBUG
            UserDefaults.standard.removeObject(forKey: Constants.CachedItems.lastPageLoaded.rawValue)
//            DataManager.shared.removeContacts()
        #endif
        
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = BaseNavigationController()
        
        applicationCoordinator.start()
        return true
    }
}

extension AppDelegate {
    fileprivate func makeCoordinator() -> Coordinator {
        return ApplicationCoordinator(router: RouterImp(rootController: rootController), coordinatorFactory: CoordinatorFactoryImp())
    }
}
