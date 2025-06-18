//
//  SoonganApp.swift
//  Soongan
//
//  Created by ParkJunHyuk on 5/7/25.
//  Copyright © 2025 Captures. All rights reserved.
//

import SwiftUI
import UserNotifications

import AuthFeature
import CoreKeyChain

import ComposableArchitecture
import Firebase
import FirebaseMessaging
import KakaoSDKAuth
import KakaoSDKCommon

@main
struct SoonganApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    init() {
        KakaoSDK.initSDK(appKey: Config.kakaoNativeAppKey)
    }
    
    var body: some Scene {
        WindowGroup {
            AppView(
                store: Store(
                    initialState: AppFeature.State(),
                    reducer:  {
                        AppFeature()
                    }
                )
            )
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        // MARK: - FireBase 설정
        
        // Firebase 초기화
        FirebaseApp.configure()
        
        // FCM Delegate 설정
        Messaging.messaging().delegate = self
        
        // UNUserNotificationCenter delegate 설정
        UNUserNotificationCenter.current().delegate = self
        
        // 원격 알림 권한 요청
        requestNotificationPermission()
        
        return true
    }
    
    // MARK: - 원격 알림 권한 요청
    
    private func requestNotificationPermission() {
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { granted, error in
            if let error = error {
                print("알림 권한 요청 실패: \(error.localizedDescription)")
                return
            }
            
            print("알림 권한 승인: \(granted)")
            
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    // MARK: - APNs 토큰 등록 성공
    
    func application(_ application: UIApplication,
                   didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        print("APNs 토큰 등록 성공")
    }
    
    // MARK: - APNs 토큰 등록 실패
    
    func application(_ application: UIApplication,
                   didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("APNs 토큰 등록 실패: \(error.localizedDescription)")
    }
}

extension AppDelegate: MessagingDelegate {
    // FCM 토큰이 갱신될 때마다 호출
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("📱 FCM 토큰 수신: \(fcmToken ?? "nil")")
        
        if let fcmToken {
            let _ = KeychainManager.shared.save(key: .fcmToken, value: fcmToken)
        }
        
        // 토큰이 변경되었음을 알리는 노티피케이션 발송
        let dataDict: [String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(
            name: Notification.Name("FCMToken"),
            object: nil,
            userInfo: dataDict
        )
        
        // 서버에 토큰 전송 (필요시)
        sendTokenToServer(fcmToken)
    }
    
    private func sendTokenToServer(_ token: String?) {
        guard let token = token else { return }
        
        // TODO: 서버에 FCM 토큰 전송하는 로직 구현
        print("서버에 토큰 전송: \(token)")
    }
}


extension AppDelegate: UNUserNotificationCenterDelegate {
    // Foreground 상태에서 알림 받았을 때 - 알림 표시만 설정
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let userInfo = notification.request.content.userInfo
        print("포그라운드 알림 수신: \(userInfo)")
        
        completionHandler([[.banner, .badge, .sound]])
    }
    
    // 알림 탭했을 때의 실제 동작 처리
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        print("SceneDelegate 푸시 메세지를 받았습니다.")
        
        let userInfo = response.notification.request.content.userInfo
        print("알림 탭:", userInfo)
//        decodeUserInfo(userInfo)
        
        // TODO: 알림 탭 시 특정 화면으로 이동하는 로직 구현
        
        completionHandler()
    }
    
    func decodeUserInfo(_ userInfo: [AnyHashable: Any]) {
        do {
            let data = try JSONSerialization.data(withJSONObject: userInfo, options: [])
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Decoded JSON: \(jsonString)")
            }
        } catch {
            print("Error decoding userInfo: \(error)")
        }
    }
}
