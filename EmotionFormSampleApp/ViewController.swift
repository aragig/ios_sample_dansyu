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
    private var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextView()
        setupEmotionButtons()
        setupDismissKeyboardGesture()

    }
    
    private func setupTextView() {
        textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.cornerRadius = 8
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        textView.isScrollEnabled = true
        textView.text = "感想やメモを入力してください..."
        textView.textColor = .lightGray
        
        // プレースホルダーのような動作を実現
        textView.delegate = self
        
        view.addSubview(textView)
        
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            textView.heightAnchor.constraint(equalToConstant: 200) // 高さを固定
        ])
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
            stackView.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 10),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
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
    
    private func setupDismissKeyboardGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true) // キーボードを閉じる
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


// プレースホルダー対応のためのUITextViewデリゲート
extension ViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "感想やメモを入力してください..." {
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "感想やメモを入力してください..."
            textView.textColor = .lightGray
        }
    }
}
