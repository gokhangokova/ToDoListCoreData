//
//  AppDelegate.swift
//  ToDoListCoreData
//
//  Created by Gokhan Gokova on 9.10.2018.
//  Copyright © 2018 Gokhan Gokova. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        print("didFinisLaunchingWithOptions")
        print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last as Any)
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
        // Uygulama aktif olandan aktif olmayan duruma geçmek üzere olduğunda gönderilir. Bu, belirli geçici kesintiler (gelen telefon araması veya SMS mesajı gibi) veya kullanıcı uygulamayı bıraktığında ve arka plan durumuna geçişi başlattığında gerçekleşebilir.
        // Devam eden görevleri duraklatmak, zamanlayıcıları devre dışı bırakmak ve grafik oluşturma geri çağrılarını geçersiz kılmak için bu yöntemi kullanın. Oyun, oyunu duraklatmak için bu yöntemi kullanmalıdır.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        // Paylaşılan kaynakları serbest bırakmak, kullanıcı verilerini kaydetmek, zamanlayıcıları geçersiz kılmak ve daha sonra sonlandırılması durumunda uygulamanızı mevcut durumuna geri yüklemek için yeterli uygulama durumu bilgilerini depolamak için bu yöntemi kullanın.
        // Uygulamanız arka planda yürütmeyi destekliyorsa, bu yöntem applicationWillTerminate yerine çağrılır: kullanıcı çıktığı zaman.
        print("applicationDidEnterBackground")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        
        // Arka plandan aktif duruma geçişin bir parçası olarak adlandırılır; Burada arka plana girerken yapılan değişikliklerin çoğunu geri alabilirsiniz.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        // Uygulama devre dışıyken duraklatılmış (veya henüz başlatılmamış) tüm görevleri yeniden başlatın. Uygulama daha önce arka plandaysa, isteğe bağlı olarak kullanıcı arayüzünü yenileyin.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        
        // Uygulama sonlandırmak üzere olduğunda çağrılır. Uygunsa verileri kaydedin. Ayrıca bkz. ApplicationDidEnterBackground :.
        // Uygulama sonlandırılmadan önce uygulamanın yönetilen nesne bağlamındaki değişiklikleri kaydeder.
        print("applicationWillTerminated")
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "ToDoListCoreData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

