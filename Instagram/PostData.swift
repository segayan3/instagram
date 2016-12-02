//
//  PostData.swift
//  Instagram
//
//  Created by Naohiro Segawa on 2016/11/30.
//  Copyright © 2016年 segayan3. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

// Firebaseから送られてくる投稿データを受け取るクラス
// Firebaseはデータの追加や更新があるとデータをFIRDataSnapshotクラスとして渡してくる
// それを受け取るのがこの自作のPostDataクラス
// という理解は正しいのか？
class PostData: NSObject {
    var id: String?
    var image: UIImage?
    var imageString: String?
    var name: String?
    var caption: String?
    var date: NSDate?
    var likes: [String] = []
    var isLiked: Bool = false
    
    init(snapshot: FIRDataSnapshot, myId: String) {
        self.id = snapshot.key // keyはこのsnapshotのid
        
        let valueDictionay = snapshot.value as! [String: AnyObject]
        
        self.imageString = valueDictionay["image"] as? String
        self.image = UIImage(data: NSData(base64Encoded: imageString!, options: .ignoreUnknownCharacters)! as Data)
        
        self.name = valueDictionay["name"] as? String
        
        self.caption = valueDictionay["caption"] as? String
        
        let time = valueDictionay["time"] as? String
        self.date = NSDate(timeIntervalSinceReferenceDate: TimeInterval(time!)!)
        
        if let likes = valueDictionay["likes"] as? [String] {
            self.likes = likes
            print("likes配列の中身: \(likes)")
        }
        
        for likeId in self.likes {
            if likeId == myId {
                self.isLiked = true
                break
            }
        }
        
    }
}
