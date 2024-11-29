//
//  CircleButtonView.swift
//  EmotionFormSampleApp
//
//  Created by Toshihiko Arai on 2024/11/29.
//

import UIKit

class CircleButtonView: UIView {
    
    private let button: UIButton = UIButton(type: .system)
    private let label: UILabel = UILabel()
    
    // ボタンがタップされたときのコールバック
    var onTap: (() -> Void)?
    
    // 初期化
    init(icon: UIImage?, labelText: String) {
        super.init(frame: .zero)
        
        // ボタンの設定
        button.setImage(icon, for: .normal)
        button.tintColor = .white
        button.backgroundColor = .lightGray
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        // ラベルの設定
        label.text = labelText
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        // サブビューを追加
        addSubview(button)
        addSubview(label)
        
        // レイアウトを設定
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalTo: self.widthAnchor), // 親ビューの幅にフィット
            button.heightAnchor.constraint(equalTo: button.widthAnchor), // 正方形にする
            button.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            button.topAnchor.constraint(equalTo: self.topAnchor),
            
            label.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 8),
            label.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            label.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    @objc private func buttonTapped() {
        onTap?() // コールバックを実行
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        button.layer.cornerRadius = button.bounds.width / 2 // ボタンを円形にする
    }
    
    // ボタンの背景色を変更するメソッド
    func updateButtonBackgroundColor(_ color: UIColor) {
        button.backgroundColor = color
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
