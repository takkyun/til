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
    
    struct PasswordConfiguration {
        var numberOfChar: Int = 0
        var isUsingLowercase = false
        var isUsingUpperCase = false
        var isUsingNumber = false
        var isUsingSymbol = false
        var allowsDuplication = false
        var extraSymbols = ""
        var charset: String {
            var string = ""
            if isUsingLowercase {
                string += "abcdefghijklmnopqrstuvwxyz"
            }
            if isUsingUpperCase {
                string += "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
            }
            if isUsingNumber {
                string += "0123456789"
            }
            if isUsingSymbol {
                string += "!#$%&()=~^|@[;:],./<>?+*}`{"
            }
            string += extraSymbols
            return string
        }
    }

    //パスワードの数(5個,10個,15個)
    var numberOfPassword = 0
    
    //文字数(8、10、20)
    var configuration = PasswordConfiguration()
    
    //UserDefaults
    let userDefault = UserDefaults.standard

    @IBAction func backButton(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    //5個
    @IBAction func numberOfFive(_ sender: UISwitch) {
        numberOfTen.isOn = false
        numberOfFifteen.isOn = false
        numberOfPassword = sender.isOn ? 5 : 0
    }
    
    //10個
    @IBAction func numberOfTen(_ sender: UISwitch) {
        numberOfFive.isOn = false
        numberOfFifteen.isOn = false
        numberOfPassword = sender.isOn ? 10 : 0
    }
    
    //15個
    @IBAction func numberOfFifteen(_ sender: UISwitch) {
        numberOfFive.isOn = false
        numberOfTen.isOn = false
        numberOfPassword = sender.isOn ? 15 : 0
    }
    
    //８文字
    @IBAction func charEight(_ sender: UISwitch) {
        //10文字と20文字をOFF
        charTen.isOn = false
        charTwenty.isOn = false
        // ---
        configuration.numberOfChar = sender.isOn ? 8 : 0
    }
    
    //10文字
    @IBAction func charTen(_ sender: UISwitch) {
        //8文字と20文字をOFF
        charEight.isOn = false
        charTwenty.isOn = false
        // ---
        configuration.numberOfChar = sender.isOn ? 10 : 0
    }
    
    //20文字
    @IBAction func charTwenty(_ sender: UISwitch) {
        //8文字と10文字をOFF
        charEight.isOn = false
        charTen.isOn = false
        // ---
        configuration.numberOfChar = sender.isOn ? 20 : 0
    }
    
    //小文字
    @IBAction func charSmall(_ sender: UISwitch) {
        configuration.isUsingLowercase = sender.isOn
    }
    
    //大文字
    @IBAction func charBig(_ sender: UISwitch) {
        configuration.isUsingUpperCase = sender.isOn
    }
    
    //記号
    @IBAction func charSymbol(_ sender: UISwitch) {
        configuration.isUsingNumber = sender.isOn
        configuration.isUsingSymbol = sender.isOn
    }
    
    //同じ文字を含めるか
    @IBAction func charSame(_ sender: UISwitch) {
        configuration.allowsDuplication = sender.isOn
    }
    
    //おまかせ（小文字と大文字を含める）
    @IBAction func randomChar(_ sender: UISwitch) {
        // パスワードの数
        numberOfPassword = 10
    
        // ---
        configuration.numberOfChar = 10
        configuration.isUsingLowercase = true
        configuration.isUsingUpperCase = true
        configuration.isUsingNumber = true
        configuration.isUsingSymbol = false
        configuration.allowsDuplication = true
        configuration.extraSymbols = ""

        // ---
        generatePasswords()
        
        dismiss(animated: true, completion: nil)
    }
    
    //カオス（小文字と大文字と記号を含める）
    @IBAction func chaosChar(_ sender: UISwitch) {
        // パスワードの数
        numberOfPassword = 15
        
        // ---
        configuration.numberOfChar = 20
        configuration.isUsingLowercase = true
        configuration.isUsingUpperCase = true
        configuration.isUsingNumber = true
        configuration.isUsingSymbol = false
        configuration.allowsDuplication = true
        configuration.extraSymbols = "σΣαβγ"

        // ---
        generatePasswords()
        
        dismiss(animated: true, completion: nil)
    }
    
    //パスワードを生成するUIButton
    @IBAction func generatePassword(_ sender: Any) {
        // ---
        configuration.extraSymbols = ""

        // ---
        generatePasswords()
        
        dismiss(animated: true, completion: nil)
    }
    
    // パスワードを生成
    func generatePasswords() {
        var passwords = [String]()
        let charset = configuration.charset
        while passwordArray.count < numberOfPassword {
            var password = ""
            while password.count < configuration.numberOfChar {
                let offset = Int(arc4random_uniform(UInt32(charset.count - 1)))
                let string = String(charset[charset.index(charset.startIndex, offsetBy: offset)])
                if configuration.allowsDuplication || !password.contains(string) {
                    password += string
                }
            }
            passwords.append(password)
        }
        userDefault.set(passwords, forKey: "passwordArray")
    }
}
