//
//  PostViewController.swift
//  Instagram
//
//  Created by Naohiro Segawa on 2016/11/26.
//  Copyright © 2016年 segayan3. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import SVProgressHUD

class PostViewController: UIViewController {
    
    // ImageSelectViewControllerから加工後の画像を受け取る変数
    var image: UIImage!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    
    // 投稿ボタンがタップされた時に呼ばれるメソッド
    @IBAction func handlePostButton(_ sender: Any) {
        // ImageViewから画像を取得する
        let imageData = UIImageJPEGRepresentation(imageView.image!, 0.5) // NSDataクラスで取得
        let imageString = imageData!.base64EncodedString(options: .lineLength64Characters) // imageDataを64種類の文字列に変換
        
        // postDataに投稿に必要な情報を取得しておく
        let time = NSDate.timeIntervalSinceReferenceDate
        let name = FIRAuth.auth()?.currentUser?.displayName
        
        // 辞書を作成してFirebaseに保存する(Firebaseは保存するデータがテキスト形式)
        let postRef = FIRDatabase.database().reference().child(Const.Postpath) // Firebase上のデータ保存先インスタンス
        let postData = ["caption": textField.text!, "image": imageString, "time": String(time), "name": name!]
        postRef.childByAutoId().setValue(postData)
        
        // HUDで投稿完了を表示する
        SVProgressHUD.showSuccess(withStatus: "投稿しました")
        
        // 全てのモーダルを閉じる
        UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    // キャンセルボタンがタップされた時に呼ばれるメソッド
    @IBAction func handleCancelButton(_ sender: Any) {
        // 画面を閉じる
        dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // 受け取った加工後画像をImageViewに設定する
        imageView.image = image
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
