//
//  ViewController.swift
//  SweetTreatTimer
//
//  Created by kudo koki on 2021/04/28.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    var timer: Timer?
    var count = 0
    let settingKey = "timer_value"

    @IBOutlet weak var countDownLabel: UILabel!
    @IBOutlet weak var inputTreatText: UITextField!
    
    // ロード時
    override func viewDidLoad() {
        super.viewDidLoad()
        // 10秒でセット。
        let settings = UserDefaults.standard
        settings.register(defaults: [settingKey: 10])
        
        //
        inputTreatText.setUnderLine()
        
        inputTreatText.delegate = self
    }
    
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
        timer = Timer.scheduledTimer(timeInterval: 1.0, // 実行する間隔
                                     target: self, // タイマーの呼び出し先。同じクラス内にあるのでself
                                     selector: #selector(self.timerInerrupt(_:)), // 呼び出したいメソッド。セレクタで指定。
                                     userInfo: nil, // メソッドに渡したい情報。今回は無し。
                                     repeats: true) // 繰り返すかどうか。falseにすると一回のみ。
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
            
            // タイマー終了のアラート
            let alertController = UIAlertController(title: "終了", message: "よく我慢できたね！", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "よし食うぞ", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
        }
    }
    
    // 設定画面から戻ってきた時に実行
    override func viewDidAppear(_ animated: Bool) {
        // カウントを0にする
        count = 0
        // タイマーの表示を更新する
        _ = displayUpdate()
    }
    
    // リターンをタップでキーボードを閉じる
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// テキストフィールドの枠線を消し、アンダーラインをつける
extension UITextField {
    func setUnderLine() {
        borderStyle = .none // 枠線非表示
        
        // 枠線を作成(UIView)。
        let underline = UIView()
        underline.frame = CGRect(x: 0, y: frame.height, width: frame.width, height: 0.75)
        underline.backgroundColor = .blue
        
        // 追加
        addSubview(underline)
        
        // 枠線を最前面に設置
        bringSubviewToFront(underline)
    }
}
