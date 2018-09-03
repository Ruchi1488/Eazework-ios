//
//  AppDelegate.swift
//  EazeWork
//
//  Created by User1 on 5/3/17.
//  Copyright © 2017 User1. All rights reserved.
//
import UIKit
import IQKeyboardManagerSwift
import Fabric
import Crashlytics
import GoogleMaps
import CoreLocation
import Firebase
import GoogleSignIn


let APPDELEGATE = UIApplication.shared.delegate
let TOP_COLOR = UIColor(red: (217/255.0), green: (2/255.0), blue: (13/255.0), alpha: 1.0)
let TOP_TEXT_COLOR = UIColor(red: CGFloat((251 / 255.0)), green: CGFloat((182 / 255.0)), blue: CGFloat((0 / 255.0)), alpha: CGFloat(1.0))
let BUTTON_GREEN_BG_COLOR = UIColor(red: (77/255.0), green: (165/255.0), blue: (77/255.0), alpha: 1.0)
let BUTTON_RED_BG_COLOR = UIColor(red: (217/255.0), green: (2/255.0), blue: (13/255.0), alpha: 1.0)

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,CLLocationManagerDelegate,GIDSignInDelegate {
    
    
    
    var window: UIWindow?
   var locationManager:CLLocationManager!
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
              Fabric.with([Crashlytics.self])
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        IQKeyboardManager.sharedManager().enable = true
        SharedManager.shareData().deviceID = UIDevice.current.identifierForVendor!.uuidString
        
        GMSServices.provideAPIKey("AIzaSyDIdkFvLh94evT4kDyC5NuRnHfvtsra95g")
       // GMSPlacesClient.provideAPIKey("AIzaSyDIdkFvLh94evT4kDyC5NuRnHfvtsra95g")
        self.determineMyCurrentLocation()
        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        // Initialize sign-in
        //GIDSignIn.sharedInstance().clientID = "YOUR_CLIENT_ID"
       // GIDSignIn.sharedInstance().delegate = self
        return true
    }

    
    func determineMyCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            //locationManager.startUpdatingHeading()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
        print("Error \(error)")
    }
    
 
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // For ios 8 plus version
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url as URL?,
                                                 sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                 annotation: options[UIApplicationOpenURLOptionsKey.annotation])
    }
    
    // For ios 8 and older version
    private func application(application: UIApplication,
                     openURL url: URL, sourceApplication: String?, annotation: Any?) -> Bool {
        var _: [String: AnyObject] = [UIApplicationOpenURLOptionsKey.sourceApplication.rawValue: sourceApplication as AnyObject,
                                      UIApplicationOpenURLOptionsKey.annotation.rawValue: annotation! as AnyObject]
        return GIDSignIn.sharedInstance().handle(url as URL?,
                                                    sourceApplication: sourceApplication,
                                                    annotation: annotation)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            // Perform any operations on signed in user here.
            //let _userId = user.userID                  // For client-side use only!
            let _gmailIdToken = user.authentication.idToken // Safe to send to the server
           print("Google Token",_gmailIdToken as Any)
            // let _fullName = user.profile.name
            //let _givenName = user.profile.givenName
           // let _familyName = user.profile.familyName
            let _email = user.profile.email
            print("Email id",_email as Any)

        }
    }

}

