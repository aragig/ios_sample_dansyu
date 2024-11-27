//
//  FormViewController.swift
//  dansyu
//
//  Created by Toshihiko Arai on 2024/11/25.
//

import UIKit

class FormViewController: UIViewController {
    var selectedDay: Date? // 選択された日付を保持するプロパティ

    private let dayLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()

    private let questionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        label.textAlignment = .center
        label.textColor = .black
        label.text = "お酒を飲みましたか？"
        return label
    }()

    private let yesButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("はい", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.fromHex("#CCCCCC")
        button.layer.cornerRadius = 50
        return button
    }()

    private let noButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("いいえ", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.fromHex("#CCCCCC")
        button.layer.cornerRadius = 50
        return button
    }()

    private let alcoholSelectionView: AlcoholSelectionView = {
        let view = AlcoholSelectionView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true // 初期状態で非表示
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupUI()
        setupActions()
    }

    private func setupUI() {
        view.addSubview(dayLabel)
        view.addSubview(questionLabel)
        view.addSubview(yesButton)
        view.addSubview(noButton)
        view.addSubview(alcoholSelectionView)

        NSLayoutConstraint.activate([
            dayLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            dayLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            questionLabel.topAnchor.constraint(equalTo: dayLabel.bottomAnchor, constant: 40),
            questionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            yesButton.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 40),
            yesButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -20),
            yesButton.widthAnchor.constraint(equalToConstant: 100),
            yesButton.heightAnchor.constraint(equalToConstant: 100),

            noButton.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 40),
            noButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 20),
            noButton.widthAnchor.constraint(equalToConstant: 100),
            noButton.heightAnchor.constraint(equalToConstant: 100),

            alcoholSelectionView.topAnchor.constraint(equalTo: yesButton.bottomAnchor, constant: 40),
            alcoholSelectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            alcoholSelectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
//            alcoholSelectionView.heightAnchor.constraint(equalToConstant: 200)
            alcoholSelectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10) // 下端に余白を取る
        ])

        if let selectedDay = selectedDay {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy年MM月dd日"
            dayLabel.text = "\(formatter.string(from: selectedDay))"
        }
    }

    private func setupActions() {
        yesButton.addTarget(self, action: #selector(didTapYes), for: .touchUpInside)
        noButton.addTarget(self, action: #selector(didTapNo), for: .touchUpInside)
    }

    @objc private func didTapYes() {
        highlightButton(yesButton, isSelected: true)
        highlightButton(noButton, isSelected: false)
        alcoholSelectionView.isHidden = false // 「はい」で表示
    }

    @objc private func didTapNo() {
        highlightButton(yesButton, isSelected: false)
        highlightButton(noButton, isSelected: true)
        alcoholSelectionView.isHidden = true // 「いいえ」で非表示
    }

    private func highlightButton(_ button: UIButton, isSelected: Bool) {
        if isSelected {
            button.backgroundColor = UIColor.systemBlue // ハイライト色
            button.setTitleColor(.white, for: .normal)
        } else {
            button.backgroundColor = UIColor.fromHex("#CCCCCC") // デフォルト色
            button.setTitleColor(.white, for: .normal)
        }
    }
}


extension UIColor {
    static func fromHex(_ hex: String, alpha: CGFloat = 1.0) -> UIColor {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0

        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}
