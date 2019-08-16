//
//  LikedListTableViewController.swift
//  Card
//
//  Created by 原田悠嗣 on 2019/08/10.
//  Copyright © 2019 原田悠嗣. All rights reserved.
//

import UIKit

class LikedListTableViewController: UITableViewController {
    
    // いいね」された名前の一覧
    var likedName: [String] = []
    // いいねされた人の職業
    var likedJob: [String] = []
    // いいねされた人の出身地
    var likedFrom: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
    }
    
    // MARK: - Table view data source
    
    // 必須:セルの数を返すメソッド
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // いいねされたユーザーの数
        return likedName.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    // 必須:セルの設定
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        //          cell.stackView.arrangedSubviews[0] = likedName[indexPath.row]
        
        // いいねされた名前を表示
        //        cell.textLabel?.text = likedName[indexPath.row]
        cell.imageView2.image = UIImage(named: likedName[indexPath.row])
        
        // スタックヴューの中身を取得
        let name = cell.stackView.arrangedSubviews[0] as! UILabel
        name.text = likedName[indexPath.row]
        
        let job = cell.stackView.arrangedSubviews[1] as! UILabel
        job.text = likedJob[indexPath.row]
        
        let from = cell.stackView.arrangedSubviews[2] as! UILabel
        from.text = likedFrom[indexPath.row]
        
        return cell
    }
    
}
