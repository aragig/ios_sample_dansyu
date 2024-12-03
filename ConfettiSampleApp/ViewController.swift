//
//  ViewController.swift
//  ConfettiSampleApp
//
//  Created by Toshihiko Arai on 2024/12/03.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addConfettiAnimation()
    }

    func addConfettiAnimation() {
        let emitterLayer = CAEmitterLayer()
        emitterLayer.emitterPosition = CGPoint(x: view.bounds.midX, y: -10)
        emitterLayer.emitterShape = .line
        emitterLayer.emitterSize = CGSize(width: view.bounds.size.width, height: 1)

        // 鮮やかでカラフルな色合い
        let colors: [UIColor] = [
            UIColor(red: 1.0, green: 0.35, blue: 0.35, alpha: 1.0), // 赤
            UIColor(red: 1.0, green: 0.8, blue: 0.2, alpha: 1.0),  // 黄色
            UIColor(red: 0.3, green: 0.8, blue: 1.0, alpha: 1.0),  // 水色
            UIColor(red: 0.5, green: 0.9, blue: 0.4, alpha: 1.0),  // 緑
            UIColor(red: 1.0, green: 0.6, blue: 0.9, alpha: 1.0),  // ピンク
            UIColor(red: 0.9, green: 0.7, blue: 1.0, alpha: 1.0)   // 紫
        ]
        
        // 細かい形状（サークルや四角など）
        let shapes = ["circle", "star", "diamond"]

        var cells: [CAEmitterCell] = []

        for color in colors {
            for shape in shapes {
                let cell = CAEmitterCell()
                cell.contents = UIImage(named: shape)?.cgImage
                cell.birthRate = 6
                cell.lifetime = 10.0
                cell.velocity = 150
                cell.velocityRange = 50
                cell.emissionLongitude = .pi
                cell.emissionRange = .pi / 4
                cell.spin = 2
                cell.spinRange = 2
                cell.scale = 0.3 // サイズを小さめに
                cell.scaleRange = 0.3
                cell.color = color.cgColor
                cells.append(cell)
            }
        }

        emitterLayer.emitterCells = cells
        view.layer.addSublayer(emitterLayer)
    }
}
