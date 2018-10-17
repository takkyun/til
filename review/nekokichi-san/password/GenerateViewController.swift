//
//  GenerateViewController.swift
//  createPassword
//
//  Created by 藤澤洋佑 on 2018/10/14.
//  Copyright © 2018年 Fujisawa-Yousuke. All rights reserved.
//

/*
 
 ※各スイッチの特徴
 
 ・パスワードの個数：いずれかがONになると、それ以外はOFF
 ・パスワードの文字数：上記と同じ
 ・パスワードの形態：上記と同じ
 
 ・同じ文字を含めるか：ON：含める、OFF：含めない
 
 ・おまかせ：10文字の小文字大文字から成るパスワードを10個生成
 ・カオス：20文字の小文字大文字記号から成るパスワードを20個生成
 
 */

import UIKit
import EMAlertController

class GenerateViewController: UIViewController {
    
    
    @IBOutlet weak var numberOfFive: UISwitch!
    @IBOutlet weak var numberOfTen: UISwitch!
    @IBOutlet weak var numberOfFifteen: UISwitch!
    @IBOutlet weak var charEight: UISwitch!
    @IBOutlet weak var charTen: UISwitch!
    @IBOutlet weak var charTwenty: UISwitch!
    @IBOutlet weak var charSmall: UISwitch!
    @IBOutlet weak var charBig: UISwitch!
    @IBOutlet weak var charSymbol: UISwitch!
    @IBOutlet weak var charSame: UISwitch!
    @IBOutlet weak var randomChar: UISwitch!
    @IBOutlet weak var chaosChar: UISwitch!
    
    //パスワードの数(5個,10個,15個)
    var numberOfPassword = 0
    
    //文字数(8、10、20)
    var numberOfChar = 0
    
    //文字の形態（0:小文字,1:大文字,2:記号）
    var formChar:[Int:Bool] = [0:false, 1:false, 2:false]
    
    //同じ文字を含めるか
    var permissionSameChar = false
    
    
    //乱数の材料となる文字列の長さ
    var len = 0
    
    //実際に生成される文字列
    var characters : String = ""
    
    //実際に格納される文字列
    var randomCharacters = ""
    
    //実際に保存する文字列
    var randomPassword = ""
    
    
    //ViewControllerに渡すための配列
    var passwordArray = [String]()
    
    //UserDefaults
    let UD = UserDefaults.standard

    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //戻る
    @IBAction func backButton(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    //5個
    @IBAction func numberOfFive(_ sender: UISwitch) {
        
        numberOfTen.isOn = false
        numberOfFifteen.isOn = false
        
        if sender.isOn == true {
            numberOfPassword = 5
        } else {
            numberOfPassword = 0
        }
        
    }
    
    //10個
    @IBAction func numberOfTen(_ sender: UISwitch) {
        
        numberOfFive.isOn = false
        numberOfFifteen.isOn = false
        
        if sender.isOn == true {
            numberOfPassword = 10
        } else {
            numberOfPassword = 0
        }
        
    }
    
    //15個
    @IBAction func numberOfFifteen(_ sender: UISwitch) {
        
        numberOfFive.isOn = false
        numberOfTen.isOn = false
        
        if sender.isOn == true {
            numberOfPassword = 15
        } else {
            numberOfPassword = 0
        }
        
    }
    
    //８文字
    @IBAction func charEight(_ sender: UISwitch) {
        
        //10文字と20文字をOFF
        charTen.isOn = false
        charTwenty.isOn = false
        
        if sender.isOn == true {
            numberOfChar = 8
        } else {
            numberOfChar = 0
        }
        
    }
    
    //10文字
    @IBAction func charTen(_ sender: UISwitch) {
        
        //8文字と20文字をOFF
        charEight.isOn = false
        charTwenty.isOn = false
        
        if sender.isOn == true {
            numberOfChar = 10
        } else {
            numberOfChar = 0
        }
        
    }
    
    //20文字
    @IBAction func charTwenty(_ sender: UISwitch) {
        
        //8文字と10文字をOFF
        charEight.isOn = false
        charTen.isOn = false
        
        if sender.isOn == true {
            numberOfChar = 20
        } else {
            numberOfChar = 0
        }
        
    }
    
    //小文字
    @IBAction func charSmall(_ sender: UISwitch) {
        
        if sender.isOn == true {
            formChar[0] = true
        } else {
            formChar[0] = false
        }
        
    }
    
    //大文字
    @IBAction func charBig(_ sender: UISwitch) {
        
        if sender.isOn == true {
            formChar[1] = true
        } else {
            formChar[1] = false
        }
        
    }
    
    //記号
    @IBAction func charSymbol(_ sender: UISwitch) {
        
        if sender.isOn == true {
            formChar[2] = true
        } else {
            formChar[2] = false
        }
        
    }
    
    //同じ文字を含めるか
    @IBAction func charSame(_ sender: UISwitch) {
        
        if sender.isOn == true {
            permissionSameChar = true
        } else {
            permissionSameChar = false
        }
        
    }
    
    //おまかせ（小文字と大文字を含める）
    @IBAction func randomChar(_ sender: UISwitch) {
        
        //文字数
        numberOfChar = 10
        
        //パスワードの数
        numberOfPassword = 10
        
        //含める文字群
        characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        //指定された条件を基にパスワードを生成
        //パスワードを配列に格納していく
        generatePasswordFunc()
        
        dismiss(animated: true, completion: nil)
        
    }
    
    //カオス（小文字と大文字と記号を含める）
    @IBAction func chaosChar(_ sender: UISwitch) {
        
        //文字数
        numberOfChar = 20
        
        //パスワードの数
        numberOfPassword = 15
        
        //含める文字
        characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!#$%&()=~^|@[;:],./<>?+*}`{σΣαβγ"
        
        //指定された条件を基にパスワードを生成
        //パスワードを配列に格納していく
        generatePasswordFunc()
        
        dismiss(animated: true, completion: nil)
        
    }
    
    //パスワードを生成するUIButton
    @IBAction func generatePassword(_ sender: Any) {
        
        //どんな文字を含めたいかを設定
        branchOfChar()
        
        //もし同じ文字を含めたい場合
        if permissionSameChar == true {
            
            //同じ文字が含まれないように生成
            generatePasswordFunc()
            
        //同じ文字を含めたくない場合
        } else {
            //普通に生成
            generateNotSamePasswordFunc()
            
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    //同じ文字を含める場合のパスワードを生成
    func generatePasswordFunc() {
        
        //パスワードの個数をfor文で生成
        for _ in 0..<numberOfPassword {
            
            //設定した文字数になるまで文字をランダムに生成
            for _ in 0..<numberOfChar {
                
                len = Int(arc4random_uniform(UInt32(characters.count - 1)))
                
                //１文字目からlen番目の文字を追加
                randomCharacters += String(characters[characters.index(characters.startIndex, offsetBy: len)])
                
            }
            
            //配列に含める
            passwordArray.append(randomCharacters)
            
            //初期化
            randomCharacters = ""
            
        }
        
        //ViewControllerに渡すための配列に追加する
        UD.set(passwordArray, forKey: "passwordArray")
        
        //初期化処理
        passwordArray = [String]()
        
        //遷移
        dismiss(animated: true, completion: nil)
        
    }
    
    //パスワード生成の関数
    func generateNotSamePasswordFunc() {
        
        //重複チェックを行うために、一旦文字を格納していく
        var sameCharArray = [String]()
        
        //重複チェック後の文字らを格納
        var notsameCharArray = [String]()
        
        for _ in 0..<numberOfPassword {
            
            //重複を繰り返し、設定した文字数になるまで繰り返す
            while (notsameCharArray.count <= numberOfChar) {
                
                len = Int(arc4random_uniform(UInt32(characters.count - 1)))
                
                //１文字目からlen番目の文字を追加
                randomCharacters = String(characters[characters.index(characters.startIndex, offsetBy: len)])
                
                //生成した乱数文字を配列に格納
                sameCharArray.append(randomCharacters)
                
                //重複チェック
                let orderSet = NSOrderedSet(array: sameCharArray)
                
                //重複のない配列
                notsameCharArray = orderSet.array as! [String]
                
                //更新
                sameCharArray = notsameCharArray
                
            }
            
            //配列を結合
            randomPassword = notsameCharArray.joined()
            
            //配列に含める
            passwordArray.append(randomPassword)
            
            //初期化
            randomCharacters = ""
            randomPassword = ""
            sameCharArray = []
            notsameCharArray = []
            
        }
        
        //ViewControllerに渡すための配列に追加する
        UD.set(passwordArray, forKey: "passwordArray")
        
        //初期化処理
        passwordArray = [String]()
        
        //遷移
        dismiss(animated: true, completion: nil)
        
    }
    
    //文字形態の条件分岐
    func branchOfChar() {
        
        switch (formChar[0],formChar[1],formChar[2]) {
        case (true, false, false): //小文字
            characters = "abcdefghijklmnopqrstuvwxyz"
        case (false, true, false): //大文字
            characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        case (false, false, true): //記号
            characters = "0123456789!#$%&()=~^|@[;:],./<>?+*}`{"
        case (true, true, false): //小文字と大文字
            characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        case (true, false, true): //小文字と記号
            characters = "abcdefghijklmnopqrstuvwxyz0123456789!#$%&()=~^|@[;:],./<>?+*}`{"
        case (false, true, true): //大文字と記号
            characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!#$%&()=~^|@[;:],./<>?+*}`{"
        case (true, true, true): //小文字と大文字と記号
            characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!#$%&()=~^|@[;:],./<>?+*}`{"
        default:
            break
        }
        
    }
    
}
