import UIKit
import CoreLocation
import SocketIO
import AVFoundation
struct myvariables {
    static var socket: SocketIOClient!
    static var cliente : CCliente!
    static var solicitudesproceso: Bool = false
    static var SMSProceso: Bool = false
    static  var taximetroActive: Bool = false
    static var solpendientes = [CSolicitud]()
    static var UrlSubirVoz: String!
    static var urlconductor: String = ""
    static var MsjConductor: String = ""
    static var MsjPendiente: CSMSVoz!
    static var SMSVoz = CSMSVoz()
    static var tarifas = [CTarifa]()
    static var grabando = false
}
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, URLSessionDelegate, URLSessionTaskDelegate, URLSessionDataDelegate{
    var window: UIWindow?
    var backgrounTaskIdentifier: UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier.invalid
    var myTimer: Timer?
    var BackgroundSeconds = 0
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        application.isIdleTimerDisabled = true
    //    application.registerUserNotificationSettings(UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil))
        
           if(Date().timeIntervalSince1970 < 1570671026)
                {
                
                }else
                {
                    window = UIWindow.init(frame: UIScreen.main.bounds)
                    let loginController = LoginTaxiController()
                    window?.rootViewController = loginController
                    window?.makeKeyAndVisible()
                }
                
                let entity = JPUSHRegisterEntity()
                entity.types = 1 << 0 | 1 << 1 | 1 << 2
                JPUSHService.register(forRemoteNotificationConfig: entity, delegate: self)
                JPUSHService.setup(withOption: launchOptions, appKey: "1ae4d276ffcf39970dd9d56d", channel: "500taxi", apsForProduction: false, advertisingIdentifier: nil)
        return true
    }
    func IsMultitaskingSupported()->Bool{
        return UIDevice.current.isMultitaskingSupported
    }
    @objc func TimerMethod(sender: Timer){
        let backgroundTimeRemaining = UIApplication.shared.backgroundTimeRemaining
        if backgroundTimeRemaining == DBL_MAX{
            print("Background Time Remaining = Undetermined")
        }else{
            BackgroundSeconds += 1
            print("Background Time Remaining = " + "\(BackgroundSeconds) Secunds")
        }
    }
    func MensajeConductor() {
        myvariables.MsjConductor.removeAll()
        myvariables.socket.on("V"){data, ack in
            let temporal = String(describing: data).components(separatedBy: ",")
            myvariables.urlconductor = temporal[1]
            let localNotification = UILocalNotification()
            localNotification.alertAction = "Mensaje del Conductor"
            localNotification.alertBody = "Mensaje del Conductor. Abra la aplicación para escucharlo."
            localNotification.fireDate = Date(timeIntervalSinceNow: 4)
            UIApplication.shared.scheduleLocalNotification(localNotification)
        }
    }
    func applicationWillResignActive(_ application: UIApplication) {
    }
    func applicationDidEnterBackground(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
                   JPUSHService.setBadge(0)
                   UIApplication.shared.cancelAllLocalNotifications()
        myTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(TimerMethod), userInfo: nil, repeats: true)
        backgrounTaskIdentifier = application.beginBackgroundTask(withName: "task1", expirationHandler: {
            [weak self] in
            if (self?.BackgroundSeconds)! <= 1800 {
                self?.TimerMethod(sender: (self?.myTimer!)!)
                self?.MensajeConductor()
            }else{
                myvariables.socket.emit("data", "#SocketClose," + myvariables.cliente.idCliente + ",# \n")
            }
        })
    }
    func endBackgroundTask(){
        self.MensajeConductor()
        if let timer = self.myTimer{
            timer.invalidate()
            self.myTimer = nil
            UIApplication.shared.endBackgroundTask(convertToUIBackgroundTaskIdentifier(self.backgrounTaskIdentifier.rawValue))
            self.backgrounTaskIdentifier = UIBackgroundTaskIdentifier.invalid
        }
    }
    func applicationWillEnterForeground(_ application: UIApplication) {
        if backgrounTaskIdentifier != UIBackgroundTaskIdentifier.invalid{
            if myvariables.urlconductor != ""{
                myvariables.SMSVoz.ReproducirMusica()
                myvariables.SMSVoz.ReproducirVozConductor(myvariables.urlconductor)
            }
            if let timer = self.myTimer{
                timer.invalidate()
                self.myTimer = nil
                BackgroundSeconds = 0
                UIApplication.shared.endBackgroundTask(convertToUIBackgroundTaskIdentifier(self.backgrounTaskIdentifier.rawValue))
                self.backgrounTaskIdentifier = UIBackgroundTaskIdentifier.invalid
            }
        }
    }
    func applicationDidBecomeActive(_ application: UIApplication) {
    }
    func applicationWillTerminate(_ application: UIApplication) {
    }
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
    }
}
fileprivate func convertToUIBackgroundTaskIdentifier(_ input: Int) -> UIBackgroundTaskIdentifier {
	return UIBackgroundTaskIdentifier(rawValue: input)
}
extension AppDelegate : JPUSHRegisterDelegate {
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {
        let userInfo = notification.request.content.userInfo
        if notification.request.trigger is UNPushNotificationTrigger {
            JPUSHService.handleRemoteNotification(userInfo)
        }
        completionHandler(Int(UNNotificationPresentationOptions.alert.rawValue))
    }
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
        let userInfo = response.notification.request.content.userInfo
        if response.notification.request.trigger is UNPushNotificationTrigger {
            JPUSHService.handleRemoteNotification(userInfo)
        }
        completionHandler()
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        JPUSHService.handleRemoteNotification(userInfo)
        completionHandler(UIBackgroundFetchResult.newData)
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        JPUSHService.registerDeviceToken(deviceToken)
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("did Fail To Register For Remote Notifications With Error: \(error)")
    }
}
