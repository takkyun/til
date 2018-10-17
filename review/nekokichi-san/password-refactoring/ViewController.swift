//
//  ViewController.swift
//  createPassword
//
//  Created by 藤澤洋佑 on 2018/10/14.
//  Copyright © 2018年 Fujisawa-Yousuke. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    
    var passwordArray = [String]()
    
    // UserDefaults
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // アプリ起動時にtableViewに表示されているパスワードを全て削除
        userDefaults.removeObject(forKey: "passwordArray")
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // userDefaultsから配列を取得
        // arrayはアンラップの為の変数
        if let array = userDefaults.object(forKey: "passwordArray") as? [String] {
            passwordArray = array
        }
        
        // リロード
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return passwordArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        // 当初はセルの上にLabelを置いていたが、コピーできなかった
        // セルのテキストにパスワードを表示
        cell.textLabel?.text = passwordArray[indexPath.row]
        // テキストを中央寄せに
        cell.textLabel?.textAlignment = .center
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // タップするとクリップボードに保存する
        UIPasteboard.general.string = passwordArray[indexPath.row]
        
    }

}

