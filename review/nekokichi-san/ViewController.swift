//
//  ViewController.swift
//  musicplayer2
//
//  Created by 藤澤洋佑 on 2018/09/24.
//  Copyright © 2018年 Fujisawa-Yousuke. All rights reserved.
//

import UIKit
import MediaPlayer

class ViewController: UIViewController,MPMediaPickerControllerDelegate {
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var songname: UILabel!
    
    @IBOutlet weak var artistname: UILabel!
    
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var scrubBar: UISlider!
    
    //MediaPlayerのインスタンスを作成
    var player:MPMusicPlayerController!
    
    //タイマー変数を定義
    var timer = Timer()
    
    //次に再生するか一時停止するかを判断
    var playorpause = 0
    
    //曲が再生される前かされた後かを判定
    var flag = 0
    
    //曲の現在位置を一次的に保持
    var currenttime = 0.0
    
    //曲の長さを保持する変数
    var timeinterval = TimeInterval()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //プレイヤーの準備
        player = MPMusicPlayerController.applicationMusicPlayer
        
        //??
        let notificationcenter = NotificationCenter.default
        notificationcenter.addObserver(self, selector: #selector(type(of: self).nowPlayingItemChanged(notification:)), name: NSNotification.Name.MPMusicPlayerControllerNowPlayingItemDidChange, object: player)
        
        //初期化
        scrubBar.value = 0.0
        //再生されてないのにタップしてエラーが出るのを防ぐため
        scrubBar.isHidden = true
        
        //初期画面をピッカー画面にする
        //誤って、再生ボタンを押してエラーが出るのを防ぐため
        //MPMediaPickerのインスタンス
        let picker = MPMediaPickerController()
        //ピッカーのデリゲートを設定
        picker.delegate = self
        //複数選択を不可にする
        picker.allowsPickingMultipleItems = true
        //ピッカー画面を表示
        present(picker, animated: true, completion: nil)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //再生中の曲が変更された時に実行
    @objc func nowPlayingItemChanged(notification:NSNotification) {
        //もし再生できる状態なら
        if let playingitem = player.nowPlayingItem {
            updatesong(mediaItem: playingitem)
        }
    }
    
    //使用した〇〇を破棄する
    deinit {
        let notificationcenter = NotificationCenter.default
        notificationcenter.removeObserver(self, name: NSNotification.Name.MPMusicPlayerControllerNowPlayingItemDidChange, object: player)
        //
        player.endGeneratingPlaybackNotifications()
    }
    
    //曲の情報を表示する
    func updatesong(mediaItem: MPMediaItem) {
        
        //曲情報を表示
        songname.text = mediaItem.albumTitle ?? "不明なタイトル"
        artistname.text = mediaItem.albumArtist ?? "不明なアーティスト"
        timeinterval = mediaItem.playbackDuration
        //アートワークを表示
        if let artwork = mediaItem.artwork {
            //アートワークの枠サイズを設定
            let image = artwork.image(at: imageView.bounds.size)
            //imageviewにがアートワークを設定する
            imageView.image = image
        } else {
            //もしアートワークがなければ、何も表示しない
            imageView.image = nil
        }
        
    }
    
    //ピッカー画面で曲が選択された時
    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        //プレイヤーを止める
        player.stop()
        //選択した曲をplayerにセット
        player.setQueue(with: mediaItemCollection)
        //選択した曲の情報をラベルやイメージビューにセット
        if let mediaitem = mediaItemCollection.items.first {
            updatesong(mediaItem: mediaitem)
        }
        //ピッカーを閉じて、破棄する
        dismiss(animated: true, completion: nil)
    }
    
    //スライダーの位置を曲の再生位置と同期する
    @objc func updateslider(){
        self.scrubBar.setValue(Float(self.player.currentPlaybackTime), animated: true)
    }
    
    //曲が選択されなかった時
    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    //選択画面へを押した場合
    @IBAction func pick(_ sender: Any) {
        //flag変数を初期化
        flag = 0
        //timerを破棄する
        timer.invalidate()
        //プレイヤーを一旦停止する
        player.pause()
        //曲が停止されたことを示す
        playButton.setImage(UIImage(named: "play.png"), for: UIControl.State())
        //MPMediaPickerのインスタンス
        let picker = MPMediaPickerController()
        //ピッカーのデリゲートを設定
        picker.delegate = self
        //複数選択を不可にする
        picker.allowsPickingMultipleItems = true
        //ピッカー画面を表示
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func play(_ sender: Any) {
        //もし停止中なら
        if playorpause == 0{
            //保持した位置を代入
            player.currentPlaybackTime = currenttime
            //再生
            player.play()
            //再生中であることを示す
            playorpause = 1
            //画像を再生のマークに
            playButton.setImage(UIImage(named: "pause.png"), for: UIControl.State())
            //もしまだ1度も再生されてなければ
            if flag == 0 {
                scrubBar.isHidden = false
                scrubBar.maximumValue = Float(timeinterval)
                flag = 1
            }
            //スライダーと曲を同期
            timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(updateslider), userInfo: nil, repeats: true)
        }
        //もし曲が再生中なら
        else {
            //停止した位置を保持
            currenttime = player.currentPlaybackTime
            //タイマーを停止し、曲を一時停止
            timer.invalidate()
            player.pause()
            playorpause = 0
            playButton.setImage(UIImage(named: "play.png"), for: UIControl.State())
        }
    }
    
    @IBAction func next(_ sender: Any) {
        player.skipToNextItem()
    }
    
    @IBAction func back(_ sender: Any) {
        player.skipToPreviousItem()
    }
    
    //スライダーを移動した位置を曲の再生位置に設定
    @IBAction func scrubAction(_ sender: Any) {
        player.currentPlaybackTime = TimeInterval(scrubBar.value)
    }
    
}

