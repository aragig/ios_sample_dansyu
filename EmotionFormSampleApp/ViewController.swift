//
//  ViewController.swift
//  EmotionFormSampleApp
//
//  Created by Toshihiko Arai on 2024/11/29.
//

import UIKit


class ViewController: UIViewController {
    
    private var selectedEmotion: EmotionLevel = .notSelected {
        didSet {
            updateButtonStates()
        }
    }
    
    private var circleButtonViews: [CircleButtonView] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupEmotionButtons()
    }
    
    private func setupEmotionButtons() {
        let emotions = EmotionLevel.allCases.filter { $0 != .notSelected }
        
        // スタックビューで配置
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        for emotion in emotions {
            let icon = UIImage(systemName: "face.smiling") // 任意のアイコン
            let circleButtonView = CircleButtonView(icon: icon, labelText: emotion.label)
            
            circleButtonView.onTap = { [weak self] in
                self?.selectedEmotion = emotion
            }
            
            stackView.addArrangedSubview(circleButtonView)
            circleButtonViews.append(circleButtonView)
        }
        
        updateButtonStates()
    }
    
    private func updateButtonStates() {
        for (index, buttonView) in circleButtonViews.enumerated() {
            let emotion = EmotionLevel(rawValue: index + 1) // `notSelected`を除外した分ずらす
            let isSelected = emotion == selectedEmotion
            buttonView.updateButtonBackgroundColor(isSelected ? .systemPink : .lightGray) // ボタンの背景色を更新
        }
    }
}

enum EmotionLevel: Int, CaseIterable {
    case notSelected = 0 // 未選択
    case worst = 1       // 最悪
    case bad = 2         // 悪い
    case neutral = 3     // 普通
    case good = 4        // 良い
    case best = 5        // 最高
    
    // ラベルを定義
    var label: String {
        switch self {
        case .notSelected: return "未選択"
        case .worst: return "最悪"
        case .bad: return "悪い"
        case .neutral: return "普通"
        case .good: return "良い"
        case .best: return "最高"
        }
    }
}
