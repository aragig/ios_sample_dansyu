//
//  AlcoholSelectionView.swift
//  dansyu
//
//  Created by Toshihiko Arai on 2024/11/27.
//

import UIKit

class AlcoholSelectionView: UIView {
    private let alcoholOptions: [(name: String, pureAlcoholContent: Double)] = [
        ("ビール 500", 20.0),   // ビール5% * 500ml * 0.8 (エタノール比重)
        ("ビール 350", 14.0),   // ビール5% * 350ml * 0.8
        ("ワイン 1本", 96.0),   // ワイン12% * 750ml * 0.8
        ("ワイン 1杯", 19.2),   // ワイン12% * 150ml * 0.8
        ("ストロング 9% 500", 36.0),   // 焼酎9% * 500ml * 0.8
        ("ストロング 9% 350", 25.2),   // 焼酎9% * 350ml * 0.8
        ("ストロング 7% 500", 28.0),   // 焼酎7% * 500ml * 0.8
        ("ストロング 7% 350", 19.6),   // 焼酎7% * 350ml * 0.8
        ("ウイスキー シングル", 9.6), // ウイスキー40% * 30ml * 0.8
        ("ウイスキー ダブル", 20.0), // ウイスキー40% * 60ml * 0.8
        ("その他", 0.0)
    ]
    
    private var selectedItems: [(name: String, count: Int)] = [] // 選択されたお酒とその本数を管理・タップ順序を保持
    private var totalPureAlcoholContent: Double = 0.0 {
        didSet {
            let truncatedValue = floor(totalPureAlcoholContent * 10) / 10 // 小数点1桁で切り捨て
            totalLabel.text = "合計純アルコール量\n\(truncatedValue)g" // 数字部分を改行
        }
    }
    
    private var historyStack: [(selectedItems: [(name: String, count: Int)], totalPureAlcoholContent: Double)] = [] // 履歴管理
    
    private let totalLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        label.textAlignment = .center
        label.text = "合計純アルコール量\n0g" // 改行をデフォルトで挿入
        label.numberOfLines = 0 // 折り返しを有効にする
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let listLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = ""
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var undoButton: UIButton = {
        let button = UIButton(type: .system)
        let icon = UIImage(systemName: "arrow.uturn.left") // Undoアイコン
        button.setImage(icon, for: .normal)
        button.tintColor = .white // アイコンの色
        button.backgroundColor = .lightGray // 薄灰色の背景
        button.layer.cornerRadius = 20 // 丸みを調整
        button.addTarget(self, action: #selector(didTapUndoButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal // 横スクロールに設定
        layout.estimatedItemSize = CGSize(width: 50, height: 40) // 推定サイズを指定して自動調整
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(AlcoholOptionCell.self, forCellWithReuseIdentifier: AlcoholOptionCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = true
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .white
        
        addSubview(totalLabel)
        addSubview(listLabel)
        addSubview(undoButton)
        addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            totalLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            totalLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            totalLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            undoButton.topAnchor.constraint(equalTo: totalLabel.bottomAnchor, constant: 10), // undoButtonをtotalLabelの下に配置
            undoButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            undoButton.widthAnchor.constraint(equalToConstant: 40),
            undoButton.heightAnchor.constraint(equalToConstant: 40),
            
            listLabel.topAnchor.constraint(equalTo: undoButton.bottomAnchor, constant: 10), // listLabelをundoButtonの下に配置
            listLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            listLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            collectionView.topAnchor.constraint(equalTo: listLabel.bottomAnchor, constant: 20), // collectionViewをlistLabelの下に配置
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            collectionView.heightAnchor.constraint(equalToConstant: 60), // 高さを固定
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
    
    private func saveCurrentStateToHistory() {
        historyStack.append((selectedItems: selectedItems, totalPureAlcoholContent: totalPureAlcoholContent))
    }
    
    
    @objc private func didTapUndoButton() {
        guard let previousState = historyStack.popLast() else { return } // 履歴が空なら何もしない
        selectedItems = previousState.selectedItems
        totalPureAlcoholContent = previousState.totalPureAlcoholContent
        updateListLabel() // ラベルを更新
    }
    
    private func updateListLabel() {
        if selectedItems.isEmpty {
            listLabel.text = ""
        } else {
            listLabel.text = selectedItems.map { "\($0.name) x \($0.count)" }.joined(separator: "\n")
        }
    }
}

// MARK: - UICollectionViewDataSource
extension AlcoholSelectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return alcoholOptions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlcoholOptionCell.identifier, for: indexPath) as? AlcoholOptionCell else {
            return UICollectionViewCell()
        }
        let option = alcoholOptions[indexPath.item]
        cell.configure(with: option.name)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension AlcoholSelectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        saveCurrentStateToHistory() // 現在の状態を保存
        let option = alcoholOptions[indexPath.item]
        
        // 既存項目を探す
        if let index = selectedItems.firstIndex(where: { $0.name == option.name }) {
            selectedItems[index].count += 1 // カウントを更新
        } else {
            selectedItems.append((name: option.name, count: 1)) // 新しい項目を追加
        }
        
        totalPureAlcoholContent += option.pureAlcoholContent
        updateListLabel()
    }
}

// MARK: - AlcoholOptionCell
class AlcoholOptionCell: UICollectionViewCell {
    static let identifier = "AlcoholOptionCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 1
        label.setContentCompressionResistancePriority(.required, for: .horizontal) // 圧縮防止
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(titleLabel)
        contentView.backgroundColor = UIColor.systemBlue
        contentView.layer.cornerRadius = 20
        contentView.layer.masksToBounds = true
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure(with title: String) {
        titleLabel.text = title
    }
}
