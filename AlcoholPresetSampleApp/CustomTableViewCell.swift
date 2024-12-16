//  CustomTableViewCell.swift
//  AlcoholPresetSampleApp
//
//  Created by Toshihiko Arai on 2024/12/12.

import UIKit

class CustomTableViewCell: UITableViewCell {
    // 各項目ラベル
    private let alcoholKeyLabel = UILabel()
    private let volumeKeyLabel = UILabel()
    private let pureAlcoholKeyLabel = UILabel()

    // 各値ラベル
    private let nameValueLabel = UILabel()
    private let alcoholValueLabel = UILabel()
    private let volumeValueLabel = UILabel()
    private let pureAlcoholValueLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        // 項目ラベル共通設定
        func configureKeyLabel(_ label: UILabel, text: String) {
            label.text = text
            label.textAlignment = .right
            label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            label.translatesAutoresizingMaskIntoConstraints = false
        }

        configureKeyLabel(alcoholKeyLabel, text: "アルコール度数:")
        configureKeyLabel(volumeKeyLabel, text: "量:")
        configureKeyLabel(pureAlcoholKeyLabel, text: "純アルコール:")

        // 値ラベル共通設定
        func configureValueLabel(_ label: UILabel) {
            label.textAlignment = .left
            label.font = UIFont.systemFont(ofSize: 14)
            label.translatesAutoresizingMaskIntoConstraints = false
        }

        nameValueLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        nameValueLabel.translatesAutoresizingMaskIntoConstraints = false

        configureValueLabel(alcoholValueLabel)
        configureValueLabel(volumeValueLabel)
        configureValueLabel(pureAlcoholValueLabel)

        // ラベルをコンテンツビューに追加
        contentView.addSubview(nameValueLabel)
        contentView.addSubview(alcoholKeyLabel)
        contentView.addSubview(alcoholValueLabel)
        contentView.addSubview(volumeKeyLabel)
        contentView.addSubview(volumeValueLabel)
        contentView.addSubview(pureAlcoholKeyLabel)
        contentView.addSubview(pureAlcoholValueLabel)

        // Auto Layout 制約
        NSLayoutConstraint.activate([
            // 名前ラベル
            nameValueLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            nameValueLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            nameValueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),

            // アルコール度数ラベル
            alcoholKeyLabel.topAnchor.constraint(equalTo: nameValueLabel.bottomAnchor, constant: 15),
            alcoholKeyLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            alcoholKeyLabel.widthAnchor.constraint(equalToConstant: 120),

            alcoholValueLabel.topAnchor.constraint(equalTo: alcoholKeyLabel.topAnchor),
            alcoholValueLabel.leadingAnchor.constraint(equalTo: alcoholKeyLabel.trailingAnchor, constant: 10),
            alcoholValueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),

            // 量ラベル
            volumeKeyLabel.topAnchor.constraint(equalTo: alcoholKeyLabel.bottomAnchor, constant: 10),
            volumeKeyLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            volumeKeyLabel.widthAnchor.constraint(equalToConstant: 120),

            volumeValueLabel.topAnchor.constraint(equalTo: volumeKeyLabel.topAnchor),
            volumeValueLabel.leadingAnchor.constraint(equalTo: volumeKeyLabel.trailingAnchor, constant: 10),
            volumeValueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),

            // 純アルコール量ラベル
            pureAlcoholKeyLabel.topAnchor.constraint(equalTo: volumeKeyLabel.bottomAnchor, constant: 10),
            pureAlcoholKeyLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            pureAlcoholKeyLabel.widthAnchor.constraint(equalToConstant: 120),

            pureAlcoholValueLabel.topAnchor.constraint(equalTo: pureAlcoholKeyLabel.topAnchor),
            pureAlcoholValueLabel.leadingAnchor.constraint(equalTo: pureAlcoholKeyLabel.trailingAnchor, constant: 10),
            pureAlcoholValueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            pureAlcoholValueLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }

    // データを設定するためのメソッド
    func configure(name: String, alcoholPercentage: Double, volume: Int, pureAlcohol: Double) {
        nameValueLabel.text = name
        alcoholValueLabel.text = "\(String(format: "%.1f", alcoholPercentage))%"
        volumeValueLabel.text = "\(volume)ml"
        pureAlcoholValueLabel.text = "\(pureAlcohol)ml"
    }
}
