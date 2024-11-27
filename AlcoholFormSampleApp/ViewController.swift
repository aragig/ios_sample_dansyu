//
//  ViewController.swift
//  AlcoholFormSampleApp
//
//  Created by Toshihiko Arai on 2024/11/27.
//

import UIKit

class ViewController: UIViewController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func onTappedClick(_ sender: Any) {
        let formVC = FormViewController() // フォームビューのコントローラー
        formVC.selectedDay = Date() // 日付をDate型で渡す
        formVC.modalPresentationStyle = .formSheet // モーダルスタイルを設定
        present(formVC, animated: true, completion: nil)

    }

}

