//
//  SceneDelegate.swift
//  TsundokuBreak
//
//  Created by Mizuki Kubota on 2020/03/23.
//  Copyright © 2020 MizukiKubota. All rights reserved.
//

import UIKit
import SwiftGifOrigin
import Onboard

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        
        let userDefault = UserDefaults.standard.bool(forKey: "firstLaunch")
        if userDefault != true { setOnBoard(.shared) }
    }


    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

extension SceneDelegate {
    private func setOnBoard(_ application: UIApplication) {
        if true {
            let content1 = OnboardingContentViewController(
                title: "ようこそ",
                body: "積読くずしは\n読書管理が気軽にできるアプリです",
                image: R.image.book_walkthrouh(),
                buttonText: "",
                action: nil
            )
            let content2 = OnboardingContentViewController(
                title: "積読リストをつくろう",
                body: "積読くずしは\nバーコードを読み取ることで\n簡単にリストをつくれます",
                image: R.image.search(),
                buttonText: "",
                action: nil
            )
            let content3 = OnboardingContentViewController(
                title: "読書進捗を確認",
                body: "読書進捗も\nこのように楽しく記録できます",
                image: UIImage.gif(name: "walkthrouh")!,
                buttonText: "",
                action: nil
            )
            let lastContent = OnboardingContentViewController(
                title: "Let's積読くずし",
                body: "積読を解消しましょう！",
                image: R.image.openBook(),
                buttonText: "はじめる",
                action: {
                    self.goMainStoryboard()
                }
            )
                        
            let vc = OnboardingViewController(
                backgroundImage: nil,
                contents: [content1, content2, content3, lastContent]
            )
            
            content1.topPadding = 100
            content2.topPadding = 100
            content3.topPadding = 100
            lastContent.topPadding = 100
            
            content1.titleLabel.textColor = UIColor.gray
            content1.bodyLabel.numberOfLines = 2;
            content1.bodyLabel.adjustsFontSizeToFitWidth = true
            content1.bodyLabel.textColor = UIColor.gray
            
            content2.titleLabel.textColor = UIColor.gray
            content2.bodyLabel.numberOfLines = 3;
            content2.bodyLabel.adjustsFontSizeToFitWidth = true
            content2.bodyLabel.textColor = UIColor.gray
            
            content3.titleLabel.textColor = UIColor.gray
            content3.bodyLabel.numberOfLines = 2;
            content3.bodyLabel.adjustsFontSizeToFitWidth = true
            content3.bodyLabel.textColor = UIColor.gray


            
            lastContent.titleLabel.textColor = UIColor.gray
            lastContent.bodyLabel.textColor = UIColor.gray
            lastContent.actionButton.setTitleColor(UIColor.gray, for: .normal)


            vc?.shouldMaskBackground = false;
            vc?.allowSkipping = true
            vc?.skipHandler = { self.goMainStoryboard() }

            lastContent.viewWillAppearBlock = {
                    vc?.skipButton.isHidden = true
            }
            lastContent.viewDidDisappearBlock = {
                    vc?.skipButton.isHidden = false
            }
            
            vc?.view.backgroundColor = UIColor.white
            vc?.skipButton.setTitleColor(UIColor.gray, for: .normal)
            vc?.pageControl.pageIndicatorTintColor = UIColor.systemGray5
            vc?.pageControl.currentPageIndicatorTintColor = UIColor.black
            window?.rootViewController = vc
        }
    }
    private func goMainStoryboard() {
        let homeView = R.storyboard.mainStoryboard.instantiateInitialViewController()
        self.window?.rootViewController = homeView
        self.window?.makeKeyAndVisible()
//        UserDefaults.standard.set(true, forKey: "firstLaunch")
    }
}
