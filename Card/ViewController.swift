//
//  ViewController.swift
//  Card
//
//  Created by 原田悠嗣 on 2019/08/10.
//  Copyright © 2019 原田悠嗣. All rights reserved.
//

import Foundation
import UIKit

struct UserData {
    // 名前
    var name: String
    // 画像
    var image: UIImage
    // 職業
    var job: String
    // 出身
    var from: String
    // 背景色
    var backGroundColor: UIColor
}


class ViewController: UIViewController {
    
    // viewの動作をコントロールする
    @IBOutlet weak var baseCard: UIView!
    // スワイプ中にgood or bad の表示
    @IBOutlet weak var likeImage: UIImageView!
    
    // ユーザーカード1の情報
    @IBOutlet weak var person1: UIView!
    @IBOutlet weak var personImage: UIImageView!
    @IBOutlet weak var personName: UILabel!
    @IBOutlet weak var personJob: UILabel!
    @IBOutlet weak var personFrom: UILabel!
    // ユーザーカード情報２
    @IBOutlet weak var person2: UIView!
    @IBOutlet weak var personImage2: UIImageView!
    @IBOutlet weak var personName2: UILabel!
    @IBOutlet weak var personJob2: UILabel!
    @IBOutlet weak var personFrom2: UILabel!
    
    
    // ベースカードの中心
    var centerOfCard: CGPoint!
    // ユーザーカードの配列
    var personList: [UIView] = []
    // どちらのビューを表示させるか
    var selectedCardCount: Int = 0
    // 次に表示させるユーザーリストの番号
    var nextShowViewCount: Int = 2
    // 現在表示させているユーザーリストの番号
    var showViewCount: Int = 0
    
    
    // ユーザーリスト
    let userList: [UserData] = [
        UserData(name: "津田梅子", image: #imageLiteral(resourceName: "津田梅子"),job: "教師", from: "千葉", backGroundColor:#colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1) ),
        UserData(name: "ジョージワシントン", image: #imageLiteral(resourceName: "ジョージワシントン"), job: "大統領", from:  "アメリカ", backGroundColor: #colorLiteral(red: 0, green: 0.9592532516, blue: 1, alpha: 1)),
        UserData(name: "ガリレオガリレイ", image: #imageLiteral(resourceName: "ガリレオガリレイ"), job: "物理学者", from: "イタリア", backGroundColor: #colorLiteral(red: 0.3059686422, green: 0.2425729334, blue: 1, alpha: 1)),
        UserData(name: "板垣退助", image: #imageLiteral(resourceName: "板垣退助"), job: "議員", from: "高知", backGroundColor: #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)),
        UserData(name: "ジョン万次郎", image: #imageLiteral(resourceName: "ジョン万次郎"), job: "冒険家", from: "アメリカ", backGroundColor: #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1))
    ]
    
    // いいねされた名前の配列
    var likedName: [String] = []
    
    // viewのレイアウト処理が完了した時に呼ばれる
    override func viewDidLayoutSubviews() {
        // ベースカードの中心を代入
        centerOfCard = baseCard.center
    }
    
    // ロード完了時によばれる
    override func viewDidLoad() {
        super.viewDidLoad()
        personList.append(person1)
        personList.append(person2)
    }
    
    // セグエによる遷移前に呼ばれる
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // 行き先の確認
        if segue.identifier == "ToLikedList" {
            // 次のビューを代入
            let vc = segue.destination as! LikedListTableViewController
            // LikedListTableViewControllerのlikedName(左)にViewCountrollewのLikedName(右)を代入
            vc.likedName = likedName
        }
    }
    
    // 完全に遷移が行われ、スクリーン上からViewControllerが表示されなくなったときに呼ばれる
    override func viewDidDisappear(_ animated: Bool) {
        selectedCardCount = 0
        showViewCount = 0
        nextShowViewCount = 2
        // リスト初期化
        likedName = []
        
        // ビューを整理
        self.view.sendSubviewToBack(person2)
        // alpha値を元に戻す
        person1.alpha = 1
        person2.alpha = 1
        
        // 二枚のビューを初期化
        // 1枚目の人物を描画
        checkUserCard(showViewNumber: 0)
        
        // 描画対象を2枚目のビューに変更
        selectedCardCount = 1
        
        //2枚目の人物を描画
        checkUserCard(showViewNumber: 1)
        
        // ユーザーカードを元に戻す
        selectedCardCount = 0
    }
    
    // ベースカードを元に戻す
    func resetCard() {
        // 位置を戻す
        baseCard.center = centerOfCard
        // 角度を戻す
        baseCard.transform = .identity
    }
    
    /// ユーザーカードを次に進める処理
    func nextUserView() {
        // 背面に持っていく
        self.view.sendSubviewToBack(personList[selectedCardCount])
        // 中央に戻す
        personList[selectedCardCount].center = centerOfCard
        personList[selectedCardCount].transform = .identity
        
        // ビューがすべての人物を描画し終わったら、ビューを真っ白にするようにする
        if nextShowViewCount < userList.count {
            checkUserCard(showViewNumber: nextShowViewCount)
        } else {
            // 背面のビューを見えなくする
            person2.alpha = 0
        }
        
        // 次のカードへ
        nextShowViewCount += 1
        showViewCount += 1
        
        if showViewCount >= userList.count {
            person1.alpha = 0
            // 遷移処理
            performSegue(withIdentifier: "ToLikedList", sender: self)
        }
        selectedCardCount = showViewCount % 2
    }
    
    func checkUserCard(showViewNumber: Int) {
        // 表示されているカードの名前を保管
        let user = userList[showViewNumber]
        // ビューを管理する
        if selectedCardCount == 0 {
            // ビューの背景に色をつける
            person1.backgroundColor = user.backGroundColor
            // 名前を表示
            personName.text = user.name
            // 職業を表示
            personJob.text = user.job
            // 出身地を表示
            personFrom.text = user.from
            // 画像を表示
            personImage.image = user.image
        } else {
            // ビューの背景に色をつける
            person2.backgroundColor = user.backGroundColor
            // 名前を表示
            personName2.text = user.name
            // 職業を表示
            personJob2.text = user.job
            // 出身地を表示
            personFrom2.text = user.from
            // 画像を表示
            personImage2.image = user.image
        }
    }
    
    /// ユーザーカードを左右に飛ばす処理
    func farCard(distance: CGFloat, button: UIButton?) {
        UIView.animate(withDuration: 0.5, animations: {
            // ユーザーカードを左にとばす
            // X座標をdistance分飛ばす
            self.personList[self.selectedCardCount].center = CGPoint(x: self.personList[self.selectedCardCount].center.x + distance, y :self.personList[self.selectedCardCount].center.y)
        })
        
        // ボタンかスワイプかを判断
        if button != nil {
            // ボタンを使えなくする(連打防止)
            button?.isEnabled = false
            // 0.5秒のdelay をかける
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.nextUserView()
                button?.isEnabled = true
            })
            
        } else {
            // 次の人物を写す
            nextUserView()
        }
        // ベースカードをリセット
        resetCard()
    }
    
    // スワイプ処理
    @IBAction func swipeCard(_ sender: UIPanGestureRecognizer) {
        // ベースカード
        let card = sender.view!
        // 動いた距離
        let point = sender.translation(in: view)
        // 取得できた距離をcard.centerに加算
        card.center = CGPoint(x: card.center.x + point.x, y: card.center.y + point.y)
        // ユーザーカードにも同じ動きをさせる
        personList[selectedCardCount].center = CGPoint(x: card.center.x + point.x, y:card.center.y + point.y)
        // 元々の位置と移動先との差
        let xfromCenter = card.center.x - view.center.x
        // 角度をつける処理
        card.transform = CGAffineTransform(rotationAngle: xfromCenter / (view.frame.width / 2) * -0.785)
        // ユーザーカードに角度をつける
        personList[selectedCardCount].transform = CGAffineTransform(rotationAngle: xfromCenter / (view.frame.width / 2) * -0.785)
        
        // likeImageの表示のコントロール
        if xfromCenter > 0 {
            // goodを表示
            likeImage.image = #imageLiteral(resourceName: "いいね")
            likeImage.isHidden = false
        } else if xfromCenter < 0 {
            // badを表示
            likeImage.image = #imageLiteral(resourceName: "よくないね")
            likeImage.isHidden = false
        }
        
        // 手を話した時の処理
        if sender.state == UIGestureRecognizer.State.ended {
            if card.center.x < 50 {
                // 左に大きくスワイプしたときの処理
                farCard(distance: -500, button: nil)
                // likeImageを隠す
                likeImage.isHidden = true
            } else if card.center.x > self.view.frame.width - 50 {
                // likeImageを隠す
                likeImage.isHidden = true
                // いいねリストに追加
                likedName.append(userList[showViewCount].name)
                // 右に大きくスワイプしたときの処理
                farCard(distance: 500, button: nil)
            } else {
                // アニメーションをつける
                UIView.animate(withDuration: 0.5, animations: {
                    // ユーザーカードを元の位置に戻す
                    self.personList[self.selectedCardCount].center = self.centerOfCard
                    // ユーザーカードの角度を元の位置に戻す
                    self.personList[self.selectedCardCount].transform = .identity
                    // ベースカードの角度と位置を戻す
                    self.resetCard()
                    // likeImageを隠す
                    self.likeImage.isHidden = true
                })
            }
        }
    }
    
    // よくないねボタン
    @IBAction func dislikeButtonTapped(_ sender: UIButton) {
        // カードを左に飛ばす動作
        farCard(distance: -500, button: sender)
    }
    // いいねボタン
    @IBAction func likeButtonTaped(_ sender: UIButton) {
        sender.isEnabled = false
        //いいねリストに追加します
        likedName.append(userList[showViewCount].name)
        // いいねを右に飛ばします
        farCard(distance: 500, button: sender)
    }
    
}
