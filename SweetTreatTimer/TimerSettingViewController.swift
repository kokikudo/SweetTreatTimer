//
//  TimerSettingViewController.swift
//  SweetTreatTimer
//
//  Created by kudo koki on 2021/04/28.
//

import UIKit

class TimerSettingViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    // PickerViewに表示させたい配列を作成
    let settingArray: [Int] = [10, 20, 30, 40, 50, 60]
    
    // 登録キー
    let settingKey = "timer_value"
    
    // PickerViewが表示する列数を指定
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // PickerViewが表示する行数を指定
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return settingArray.count
    }
    
    // PickerViewが表示する内容
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(settingArray[row])
    }
    
    // Picker選択時に実行
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // UserDefaultに登録
        UserDefaults.standard.set(settingArray[row], forKey: settingKey)
        UserDefaults.standard.synchronize()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // このViewを起動時に、PickerViewに保存した値をセット
        timerSettingPicker.delegate = self
        timerSettingPicker.dataSource = self
        let timerValue = UserDefaults.standard.integer(forKey: settingKey)
        for row in 0..<settingArray.count {
            if settingArray[row] == timerValue {
                timerSettingPicker.selectRow(row, inComponent: 0, animated: true)
            }
        }
    }
    
    @IBOutlet weak var timerSettingPicker: UIPickerView!
    
    
    // 決定ボタンの処理
    @IBAction func decisionButtonAction(_ sender: Any) {
        // 前画面に戻る
        _ = navigationController?.popViewController(animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
