//
//  CalendarMonthViewController.swift
//  dansyu
//
//  Created by Toshihiko Arai on 2024/11/24.
//

import UIKit

class CalendarMonthViewController: UIViewController {
    private var collectionView: UICollectionView!
    private var days: [String] = []
    private let weekdays = ["日", "月", "火", "水", "木", "金", "土"]
    private let calendar = Calendar.current
    var currentMonth: Date = Date()

    private let monthLabel: UILabel = { // 西暦と月を表示するラベル
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupDays()
        updateMonthLabel()
    }

    func setMonth(date: Date) {
        self.currentMonth = date
    }

    private func setupUI() {
        // 月ラベルの設定
        view.addSubview(monthLabel)
        view.backgroundColor = .white

        NSLayoutConstraint.activate([
            monthLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            monthLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            monthLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            monthLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
        // カレンダー部分のレイアウト
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        layout.itemSize = CGSize(width: view.bounds.width / 7 - 1, height: view.bounds.width / 5 - 1)

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.register(CustomCalendarCell.self, forCellWithReuseIdentifier: CustomCalendarCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self

        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: monthLabel.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupDays() {
        let components = calendar.dateComponents([.year, .month], from: currentMonth)
        guard let startOfMonth = calendar.date(from: components) else { return }

        // 1日が始まる曜日
        let weekday = calendar.component(.weekday, from: startOfMonth)
        let daysInMonth = calendar.range(of: .day, in: .month, for: currentMonth)?.count ?? 0

        days = weekdays
        days.append(contentsOf: Array(repeating: "", count: weekday - 1))
        days.append(contentsOf: (1...daysInMonth).map { String($0) })

        collectionView.reloadData()
    }
    
    private func updateMonthLabel() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年 MM月"
        monthLabel.text = formatter.string(from: currentMonth)
    }
}

extension CalendarMonthViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return days.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCalendarCell.identifier, for: indexPath) as? CustomCalendarCell else {
            return UICollectionViewCell()
        }
        
        let day = days[indexPath.item]
        let isToday = isToday(dateString: day)
        let column = indexPath.item % 7 // 曜日を判定（0: 日曜日, 6: 土曜日）
        
        var textColor: UIColor = .black
        if column == 0 { // 日曜日
            textColor = .red
        } else if column == 6 { // 土曜日
            textColor = .gray
        }

        cell.configure(day: day, isToday: isToday, textColor: textColor)
        return cell
    }

    private func isToday(dateString: String) -> Bool {
        guard let day = Int(dateString) else { return false }

        let todayComponents = calendar.dateComponents([.year, .month, .day], from: Date())
        let currentComponents = calendar.dateComponents([.year, .month], from: currentMonth)

        return todayComponents.year == currentComponents.year &&
               todayComponents.month == currentComponents.month &&
               todayComponents.day == day
    }
}

extension CalendarMonthViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedDay = days[indexPath.item]
        guard !selectedDay.isEmpty else { return } // 空白セルを無視
        
        presentFormView(for: selectedDay)
    }

    private func presentFormView(for day: String) {
        print(day)
    }
}
