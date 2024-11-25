//
//  CalendarCell.swift
//  dansyu
//
//  Created by Toshihiko Arai on 2024/11/25.
//

import UIKit

class CustomCalendarCell: UICollectionViewCell {
    static let identifier = "CustomCalendarCell"

    private let dayLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(dayLabel)

        NSLayoutConstraint.activate([
            dayLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5), // 上に余白を設定
            dayLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            dayLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            dayLabel.heightAnchor.constraint(equalToConstant: 20) // 高さを固定
        ])
        
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(day: String, isToday: Bool = false, textColor: UIColor = .black) {
        dayLabel.text = day
        dayLabel.textColor = textColor
        contentView.backgroundColor = isToday ? .systemYellow : .clear
    }
}
