//
//  ViewController.swift
//  AlcoholMeterSampleApp
//
//  Created by Toshihiko Arai on 2024/11/27.
//

import UIKit


class ViewController: UIViewController {
    
    @IBOutlet weak var totalLabel: UILabel!
    
    private var totalPureAlcoholContent: Double = 0.0
    private let progressBar = VerticalProgressBar()

    override func viewDidLoad() {
        super.viewDidLoad()

        // プログレスバーをプログラムで追加
        progressBar.frame = CGRect(x: 150, y: 100, width: 30, height: 300)
        progressBar.maxAlcoholContent = 60.0 // 最大値を設定
        view.addSubview(progressBar)
        
        // ラベル追加
        totalLabel.text = "0.0 g"
        totalLabel.tag = 101 // ラベルをタグで管理
        view.addSubview(totalLabel)
    }
    
    @IBAction func onTappedClick(_ sender: Any) {
        let randomAlcohol = Double.random(in: 2.0...10.0)
        totalPureAlcoholContent += randomAlcohol
        
        // プログレスバーの更新
        progressBar.progress = totalPureAlcoholContent
        
        // ラベルの更新
        totalLabel.text = String(format: "%.1f g", totalPureAlcoholContent)
    }
    
    
    @IBAction func onTappedReset(_ sender: UIButton) {
        totalPureAlcoholContent = 0.0
        progressBar.reset()
        totalLabel.text = String(format: "%.1f g", totalPureAlcoholContent)
    }
    
    
    
}

