//
//  ViewController.swift
//  SweetTreatTimer
//
//  Created by kudo koki on 2021/04/28.
//

import UIKit

class ViewController: UIViewController {

    var timer: Timer?
    var count = 0
    let settingKey = "timer_value"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // テスト
        
        let settings = UserDefaults.standard
        settings.register(defaults: [settingKey: 10])
        
    }

    @IBOutlet weak var countDownLabel: UILabel!
    
    // 秒数設定ボタンの処理
    @IBAction func settingButtonAction(_ sender: Any) {
        // タイマーが実行中なら停止
        if let nowTimer = timer {
            if nowTimer.isValid == true {
                nowTimer.invalidate()
            }
        }
        // 画面遷移
        performSegue(withIdentifier: "goSetting", sender: nil)
    }
    
    // スタートボタンをタップ時の処理
    @IBAction func startButtonAction(_ sender: Any) {
        
        // Timerが起動中ならreturn
        if let nowTimer = timer {
            if nowTimer.isValid == true {
                return
            }
        }
        
        // タイマースタート
        // Timer.scheduledTimer(): ある処理を一定間隔で実行する関数
        // timeInterval: 実行する間隔
        // target: タイマーの呼び出し先。同じクラス内にあるのでself
        // selector: 呼び出したいメソッド。セレクタで指定。
        // userInfo: メソッドに渡したい情報。今回は無し。
        // repeats: 繰り返すかどうか。falseにすると一回のみ。
        timer = Timer.scheduledTimer(timeInterval: 1.0,
                                     target: self,
                                     selector: #selector(self.timerInerrupt(_:)),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    // ストップボタンの処理
    @IBAction func stopButtonAction(_ sender: Any) {
        
        // 実行中なら停止
        if let nowTimer = timer {
            if nowTimer.isValid == true {
                nowTimer.invalidate()
            }
        }
    }
    
    // 残り時間の表記を更新
    func displayUpdate() -> Int {
        let settings = UserDefaults.standard
        let timerValue = settings.integer(forKey: settingKey)
        let remainCount = timerValue - count
        countDownLabel.text = "残り\(remainCount)秒"
        return remainCount
    }
    
    // 経過時間の処理
    @objc func timerInerrupt(_ timer: Timer) {
        count += 1
        
        // 残り時間が0でタイマー停止
        if displayUpdate() <= 0 {
            count = 0
            timer.invalidate()
        }
    }
    
    // 設定画面から戻ってきた時に実行
    override func viewDidAppear(_ animated: Bool) {
        // カウントを0にする
        count = 0
        // タイマーの表示を更新する
        _ = displayUpdate()
    }
}

