//
//  DetailViewController.swift
//  AlcoholPresetSampleApp
//
//  Created by Toshihiko Arai on 2024/12/12.
//

import UIKit

protocol DetailViewControllerDelegate: AnyObject {
    func didSavePreset(_ preset: AlcoholPreset, at index: Int?)
}


class DetailViewController: UIViewController {
    // UIコンポーネント
    private let nameLabel = UILabel()
    private let nameTextField = UITextField()
    private let alcoholLabel = UILabel()
    private let alcoholPercentageTextField = UITextField()
    private let alcoholUnitLabel = UILabel()
    private let volumeLabel = UILabel()
    private let volumeTextField = UITextField()
    private let volumeUnitLabel = UILabel()
    private let pureAlcoholLabel = UILabel()
    private let pureAlcoholTextField = UITextField()
    private let pureAlcoholUnitLabel = UILabel()
    private let saveButton = UIButton(type: .system)

    var preset: AlcoholPreset?
    var index: Int?
    weak var delegate: DetailViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        populateData()
        updatePureAlcoholField()

        // テキストフィールドの値変更を監視
        alcoholPercentageTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        volumeTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }

    private func setupUI() {
        // ラベルの共通設定
        func setupLabel(_ label: UILabel, text: String) {
            label.text = text
            label.textAlignment = .right
            label.translatesAutoresizingMaskIntoConstraints = false
        }

        // 各ラベルの設定
        setupLabel(nameLabel, text: "名前:")
        setupLabel(alcoholLabel, text: "アルコール度数:")
        setupLabel(volumeLabel, text: "量:")
        setupLabel(pureAlcoholLabel, text: "純アルコール量:")

        // 各テキストフィールドと単位ラベルの設定
        nameTextField.placeholder = "酒の名前"
        nameTextField.borderStyle = .roundedRect
        nameTextField.translatesAutoresizingMaskIntoConstraints = false

        alcoholPercentageTextField.placeholder = "例: 5.0"
        alcoholPercentageTextField.keyboardType = .decimalPad
        alcoholPercentageTextField.borderStyle = .roundedRect
        alcoholPercentageTextField.translatesAutoresizingMaskIntoConstraints = false

        alcoholUnitLabel.text = "%"
        alcoholUnitLabel.translatesAutoresizingMaskIntoConstraints = false

        volumeTextField.placeholder = "例: 500"
        volumeTextField.keyboardType = .decimalPad
        volumeTextField.borderStyle = .roundedRect
        volumeTextField.translatesAutoresizingMaskIntoConstraints = false

        volumeUnitLabel.text = "ml"
        volumeUnitLabel.translatesAutoresizingMaskIntoConstraints = false

        pureAlcoholTextField.placeholder = ""
        pureAlcoholTextField.keyboardType = .decimalPad
        pureAlcoholTextField.borderStyle = .roundedRect
        pureAlcoholTextField.isEnabled = false
        pureAlcoholTextField.translatesAutoresizingMaskIntoConstraints = false

        pureAlcoholUnitLabel.text = "ml"
        pureAlcoholUnitLabel.translatesAutoresizingMaskIntoConstraints = false

        saveButton.setTitle("保存", for: .normal)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        saveButton.translatesAutoresizingMaskIntoConstraints = false

        // ビューに追加
        view.addSubview(nameLabel)
        view.addSubview(nameTextField)
        view.addSubview(alcoholLabel)
        view.addSubview(alcoholPercentageTextField)
        view.addSubview(alcoholUnitLabel)
        view.addSubview(volumeLabel)
        view.addSubview(volumeTextField)
        view.addSubview(volumeUnitLabel)
        view.addSubview(pureAlcoholLabel)
        view.addSubview(pureAlcoholTextField)
        view.addSubview(pureAlcoholUnitLabel)
        view.addSubview(saveButton)

        // 定数設定
        let labelWidth: CGFloat = 120
        let fieldSpacing: CGFloat = 10

        // Auto Layout
        NSLayoutConstraint.activate([
            // 名前ラベルとフィールド
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameLabel.widthAnchor.constraint(equalToConstant: labelWidth),

            nameTextField.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
            nameTextField.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: fieldSpacing),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            // アルコール度数ラベルとフィールド
            alcoholLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20),
            alcoholLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            alcoholLabel.widthAnchor.constraint(equalToConstant: labelWidth),

            alcoholPercentageTextField.centerYAnchor.constraint(equalTo: alcoholLabel.centerYAnchor),
            alcoholPercentageTextField.leadingAnchor.constraint(equalTo: alcoholLabel.trailingAnchor, constant: fieldSpacing),
            alcoholPercentageTextField.widthAnchor.constraint(equalToConstant: 100),

            alcoholUnitLabel.centerYAnchor.constraint(equalTo: alcoholPercentageTextField.centerYAnchor),
            alcoholUnitLabel.leadingAnchor.constraint(equalTo: alcoholPercentageTextField.trailingAnchor, constant: fieldSpacing),

            // 量ラベルとフィールド
            volumeLabel.topAnchor.constraint(equalTo: alcoholLabel.bottomAnchor, constant: 20),
            volumeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            volumeLabel.widthAnchor.constraint(equalToConstant: labelWidth),

            volumeTextField.centerYAnchor.constraint(equalTo: volumeLabel.centerYAnchor),
            volumeTextField.leadingAnchor.constraint(equalTo: volumeLabel.trailingAnchor, constant: fieldSpacing),
            volumeTextField.widthAnchor.constraint(equalToConstant: 100),

            volumeUnitLabel.centerYAnchor.constraint(equalTo: volumeTextField.centerYAnchor),
            volumeUnitLabel.leadingAnchor.constraint(equalTo: volumeTextField.trailingAnchor, constant: fieldSpacing),

            // 純アルコール量ラベルとフィールド
            pureAlcoholLabel.topAnchor.constraint(equalTo: volumeLabel.bottomAnchor, constant: 20),
            pureAlcoholLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            pureAlcoholLabel.widthAnchor.constraint(equalToConstant: labelWidth),
            
            pureAlcoholTextField.centerYAnchor.constraint(equalTo: pureAlcoholLabel.centerYAnchor),
            pureAlcoholTextField.leadingAnchor.constraint(equalTo: pureAlcoholLabel.trailingAnchor, constant: fieldSpacing),
            pureAlcoholTextField.widthAnchor.constraint(equalToConstant: 100),
            
            pureAlcoholUnitLabel.centerYAnchor.constraint(equalTo: pureAlcoholTextField.centerYAnchor),
            pureAlcoholUnitLabel.leadingAnchor.constraint(equalTo: pureAlcoholTextField.trailingAnchor, constant: fieldSpacing),
            
            // 保存ボタン
            saveButton.topAnchor.constraint(equalTo: pureAlcoholTextField.bottomAnchor, constant: 40),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    private func populateData() {
        // データをUIに反映
        if let preset = preset {
            nameTextField.text = preset.name
            alcoholPercentageTextField.text = "\(preset.alcoholPercentage)"
            volumeTextField.text = "\(preset.volume)"
        }
    }

    @objc private func saveButtonTapped() {
        // 入力内容を検証
        guard let name = nameTextField.text,
              let alcoholPercentageText = alcoholPercentageTextField.text,
              let alcoholPercentage = Double(alcoholPercentageText),
              let volumeText = volumeTextField.text,
              let volume = Int(volumeText) else {
            // 入力が不完全な場合は処理を中断
            print("入力値が不正です！")
            return
        }

        // 新しいプリセットを作成
        let newPreset = AlcoholPreset(name: name, alcoholPercentage: alcoholPercentage, volume: volume)

        // デリゲートを通じてデータを戻す
        delegate?.didSavePreset(newPreset, at: index)
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        updatePureAlcoholField()
    }

    private func updatePureAlcoholField() {
        guard let alcoholPercentageText = alcoholPercentageTextField.text,
              let alcoholPercentage = Double(alcoholPercentageText),
              let volumeText = volumeTextField.text,
              let volume = Int(volumeText) else {
            pureAlcoholTextField.text = ""
            return
        }

        let preset = AlcoholPreset(name: "", alcoholPercentage: alcoholPercentage, volume: volume)
        pureAlcoholTextField.text = "\(preset.pureAlcohol)"
    }
}


