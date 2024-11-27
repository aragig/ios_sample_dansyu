//
//  VerticalProgressBar.swift
//  AlcoholMeterSampleApp
//
//  Created by Toshihiko Arai on 2024/11/27.
//

import UIKit


class VerticalProgressBar: UIView {
    
    private let containerView = UIView() // 背景コンテナ
    private let progressBar = UIView() // プログレスバー
    private let arrowView = UIView() // 三角形の矢印を表示するビュー
    private let currentArrowView = UIView() // 現在の状態を示す矢印
    var maxAlcoholContent: Double = 60.0 // 最大値を設定
    var maxAlcoholContentTitle: String = "非常に高リスク" // 最大値のタイトル
    
    private var internalProgress: Double = 0.0 // プログレスバーの進捗状況
    
    var progress: Double {
        get {
            internalProgress
        }
        set {
            internalProgress = newValue
            updateProgress()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        // 背景コンテナ
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.lightGray.cgColor
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 5 // 背景のみ角丸にする
        addSubview(containerView)
        
        // プログレスバー
        progressBar.backgroundColor = .green
        containerView.addSubview(progressBar)
        
        // 最大値を示す矢印を作成
        arrowView.backgroundColor = .clear
        addSubview(arrowView)
        
        // 現在の状態を示す矢印を作成
        currentArrowView.backgroundColor = .clear
        addSubview(currentArrowView)
 
    }
    
    // レイアウトの更新
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.frame = bounds
        updateProgress()
    }
    
    // プログレスバーの更新
    private func updateProgress() {
        let containerHeight = containerView.bounds.height

        // プログレスバーの高さを計算
        let progressHeight = CGFloat(min(internalProgress / maxAlcoholContent, 1.0)) * containerHeight

        // アニメーションでプログレスバーの増加をスムーズに
        UIView.animate(withDuration: 0.3, animations: {
            self.progressBar.frame = CGRect(
                x: 0,
                y: containerHeight - progressHeight,
                width: self.containerView.bounds.width,
                height: progressHeight
            )
        })

        // 矢印の位置を更新
        let arrowPosition: CGFloat
        if internalProgress > maxAlcoholContent {
            arrowPosition = CGFloat((maxAlcoholContent / internalProgress) * containerHeight)
        } else {
            arrowPosition = CGFloat(containerHeight)
        }

        updateArrow(position: arrowPosition)
        updateCurrentArrow(position: containerHeight - progressHeight)

        // 色のアニメーションを追加
        animateColorChange(for: progressBar, to: calculateColor(for: internalProgress))
    }
    
    // 色のアニメーション
    private func animateColorChange(for view: UIView, to color: UIColor) {
        UIView.transition(with: view, duration: 0.3, options: [.transitionCrossDissolve], animations: {
            view.backgroundColor = color
        })
    }
    
    // 進捗に応じた色を計算
    private func calculateColor(for progress: Double) -> UIColor {
        // 色の範囲（緑→黄色→赤→黒）
        let green = UIColor.green
        let yellow = UIColor.yellow
        let red = UIColor.red
        let black = UIColor.black
        
        if progress <= maxAlcoholContent {
            // 緑→黄色→赤の間
            let normalizedProgress = progress / maxAlcoholContent
            if normalizedProgress < 0.5 {
                return interpolateColor(from: green, to: yellow, fraction: CGFloat(normalizedProgress * 2.0))
            } else {
                return interpolateColor(from: yellow, to: red, fraction: CGFloat((normalizedProgress - 0.5) * 2.0))
            }
        } else {
            // 赤→黒の間
            let overLimitProgress = (progress - maxAlcoholContent) / maxAlcoholContent
            return interpolateColor(from: red, to: black, fraction: CGFloat(min(overLimitProgress, 1.0)))
        }
    }
    
    // 色の補間
    private func interpolateColor(from: UIColor, to: UIColor, fraction: CGFloat) -> UIColor {
        // UIColorのコンポーネントを取得
        var fromRed: CGFloat = 0, fromGreen: CGFloat = 0, fromBlue: CGFloat = 0, fromAlpha: CGFloat = 0
        var toRed: CGFloat = 0, toGreen: CGFloat = 0, toBlue: CGFloat = 0, toAlpha: CGFloat = 0
        
        from.getRed(&fromRed, green: &fromGreen, blue: &fromBlue, alpha: &fromAlpha)
        to.getRed(&toRed, green: &toGreen, blue: &toBlue, alpha: &toAlpha)
        
        // 線形補間で色を計算
        let red = fromRed + (toRed - fromRed) * fraction
        let green = fromGreen + (toGreen - fromGreen) * fraction
        let blue = fromBlue + (toBlue - fromBlue) * fraction
        let alpha = fromAlpha + (toAlpha - fromAlpha) * fraction
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    // 矢印の位置を更新
    private func updateArrow(position: CGFloat) {

        let arrowWidth: CGFloat = 10
        let arrowHeight: CGFloat = 10
        let horizontalBarWidth: CGFloat = containerView.bounds.width // 水平棒の幅

        // 三角形と水平棒を一つのパスで描画
        let path = UIBezierPath()

        // 三角形の描画（右側）
        path.move(to: CGPoint(x: arrowWidth, y: 0))
        path.addLine(to: CGPoint(x: 0, y: arrowHeight / 2))
        path.addLine(to: CGPoint(x: arrowWidth, y: arrowHeight))
        path.close()

        // 水平棒の描画
        path.move(to: CGPoint(x: -horizontalBarWidth, y: arrowHeight / 2)) // 棒の始点
        path.addLine(to: CGPoint(x: 0, y: arrowHeight / 2)) // 棒の終点


        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.black.cgColor
        shapeLayer.strokeColor = UIColor.white.cgColor // 水平棒の色
        shapeLayer.lineWidth = 2.0 // 水平棒の太さ

        arrowView.layer.sublayers?.forEach { $0.removeFromSuperlayer() } // 既存の三角形を削除
        arrowView.layer.addSublayer(shapeLayer)

        // アニメーションで矢印の移動をスムーズに
        UIView.animate(withDuration: 0.3, animations: {
            self.arrowView.frame = CGRect(
                x: self.containerView.frame.maxX + 5,
                y: self.bounds.height - position - (arrowHeight / 2) + 2,
                width: arrowWidth,
                height: arrowHeight
            )
        })


        // ラベルを追加または更新
        if let label = viewWithTag(9001) as? UILabel {
            UIView.animate(withDuration: 0.3, animations: {
                label.frame = CGRect(
                    x: self.arrowView.frame.maxX + 5,
                    y: self.arrowView.frame.midY - 10,
                    width: 80,
                    height: 20
                )
            })
        } else {
            let label = UILabel()
            label.text = maxAlcoholContentTitle
            label.font = UIFont.systemFont(ofSize: 12)
            label.textColor = .black
            label.tag = 9001 // ラベルをタグで管理
            label.frame = CGRect(
                x: arrowView.frame.maxX + 5,
                y: arrowView.frame.midY - 10,
                width: 80,
                height: 20
            )
            addSubview(label)
        }
    }
    
    
    // 現在の状態を示す矢印の位置を更新
    private func updateCurrentArrow(position: CGFloat) {
        let arrowWidth: CGFloat = 10
        let arrowHeight: CGFloat = 10

        // 矢印を三角形に描画（現在の状態を示す矢印）
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: arrowWidth, y: arrowHeight / 2))
        path.addLine(to: CGPoint(x: 0, y: arrowHeight))
        path.close()

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.black.cgColor

        currentArrowView.layer.sublayers?.forEach { $0.removeFromSuperlayer() } // 既存の三角形を削除
        currentArrowView.layer.addSublayer(shapeLayer)

        // アニメーションで矢印の移動をスムーズに
        UIView.animate(withDuration: 0.3, animations: {
            self.currentArrowView.frame = CGRect(
                x: self.containerView.frame.minX - 15,
                y: position - 5,
                width: arrowWidth,
                height: arrowHeight
            )
        })
        
        // ラベルを追加または更新
        if let label = viewWithTag(9002) as? UILabel {
            // ラベルの値を更新
            label.text = String(format: "%.1fg", internalProgress)
            UIView.animate(withDuration: 0.3, animations: {
                label.frame = CGRect(
                    x: self.currentArrowView.frame.minX - 55, // 三角形の左側に配置
                    y: self.currentArrowView.frame.midY - 10,
                    width: 50,
                    height: 20
                )
            })
        } else {
            let label = UILabel()
            label.text = String(format: "%.1fg", internalProgress)
            label.font = UIFont.systemFont(ofSize: 12)
            label.textColor = .black
            label.textAlignment = .right
            label.tag = 9002 // ラベルをタグで管理
            label.frame = CGRect(
                x: currentArrowView.frame.minX - 55, // 三角形の左側に配置
                y: currentArrowView.frame.midY - 10,
                width: 50,
                height: 20
            )
            addSubview(label)
        }
    }

    // 水平線を描画
    private func drawHorizontalLine(at yPosition: CGFloat) {
        // 既存の水平線を削除
        containerView.layer.sublayers?.removeAll(where: { $0.name == "HorizontalLine" })

        // 水平線を描画
        let linePath = UIBezierPath()
        linePath.move(to: CGPoint(x: 0, y: yPosition))
        linePath.addLine(to: CGPoint(x: containerView.bounds.width, y: yPosition))

        let lineLayer = CAShapeLayer()
        lineLayer.path = linePath.cgPath
        lineLayer.strokeColor = UIColor.white.cgColor // 水平線を白色に設定
        lineLayer.lineWidth = 2.0 // 線の太さを調整
        lineLayer.shadowColor = UIColor.black.cgColor // 影を追加して視認性を向上
        lineLayer.shadowOpacity = 0.8
        lineLayer.shadowRadius = 1
        lineLayer.shadowOffset = CGSize(width: 0, height: 1)
        lineLayer.name = "HorizontalLine" // 識別のため名前を付ける

        containerView.layer.addSublayer(lineLayer)
    }
    
    // リセット機能
    func reset() {
        internalProgress = 0.0
        updateProgress()
        
        // ラベルを削除
        if let label = viewWithTag(9001) as? UILabel {
            label.removeFromSuperview()
        }
    }
}
