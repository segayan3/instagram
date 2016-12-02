//
//  ViewController.swift
//  Instagram
//
//  Created by Naohiro Segawa on 2016/11/26.
//  Copyright © 2016年 segayan3. All rights reserved.
//

import UIKit
import ESTabBarController
import Firebase
import FirebaseAuth

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setUpTab()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // ログインしているかどうか確認する
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("ログインビューを開く")
        // currentUserがnilならログインしていない
        if(FIRAuth.auth()?.currentUser == nil) {
            // ログインしていなければログイン画面を表示する
            // viewDidAppear内でpresent()を呼び出しても表示されないため、メソッドが終了してから呼ばれるようにする
            DispatchQueue.main.async {
                let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login")
                self.present(loginViewController!, animated: true, completion: nil)
            }
        }
    }
    
    // ESTabBarControllerを使ってタブを設定
    func setUpTab() {
        // 画像のファイル名を指定してESTabBarControllerを作成する
        let tabBarController: ESTabBarController = ESTabBarController(tabIconNames: ["home", "camera", "setting"])
        
        // ボタンの背景色、選択時の色を設定する
        tabBarController.selectedColor = UIColor(red: 1.0, green: 0.44, blue: 0.11, alpha: 1) // ボタンが選択された時の色
        tabBarController.buttonsBackgroundColor = UIColor(red: 0.96, green: 0.91, blue: 0.87, alpha: 1) // タブの背景色
        
        // 作成したESTabBarControllerを親であるViewController(つまりこのコントローラー)に追加する
        addChildViewController(tabBarController) // コントローラー自体をaddし、
        view.addSubview(tabBarController.view) // 親viewにtabBarControllerのviewをaddし、
        tabBarController.view.frame = view.bounds // tabBarControllerのviewのサイズは親viewのサイズと同じとし、
        tabBarController.didMove(toParentViewController: self) // addChildViewControllerとセットで使うメソッド(子view追加関連タスクの完了を伝える)
        
        // タブをタップした時に表示するViewControllerを設定する
        let homeViewController = storyboard?.instantiateViewController(withIdentifier: "Home")
        let settingViewController = storyboard?.instantiateViewController(withIdentifier: "Setting")
        
        tabBarController.setView(homeViewController, at: 0) // コントローラーを割り当てないと、ボタン背景色や選択時の色が反映されない
        tabBarController.setView(settingViewController, at: 2) // コントローラーを割り当てないと、ボタン背景色や選択時の色が反映されない
        
        // 真ん中のタブはボタンとして扱う
        tabBarController.highlightButton(at: 1) // ボタンとしてハイライト表示　
        tabBarController.setAction({
            // ボタンが押されたらImageViewControllerをモーダルで表示する
            let imageViewController = self.storyboard?.instantiateViewController(withIdentifier: "ImageSelect")
            self.present(imageViewController!, animated: true, completion: nil)
        }, at: 1)
    }


}

