//
//  ViewController.swift
//  RealmSampleApp
//
//  Created by Toshihiko Arai on 2024/11/29.
//

import UIKit
import RealmSwift

class DiaryEntry: Object {
    @Persisted(primaryKey: true) var id: String // プライマリキーを設定
    @Persisted var date: Date
    @Persisted var content: String
}


class ViewController: UIViewController {

    // UIコンポーネント
    let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    let textView: UITextView = {
        let textView = UITextView()
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 1.0
        textView.layer.cornerRadius = 5.0
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("保存", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let loadButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("読み込み", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let resultLabel: UILabel = {
        let label = UILabel()
        label.text = "日記がここに表示されます"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    

    let idTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "削除したいIDを入力"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("削除", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        
        saveButton.addTarget(self, action: #selector(saveDiary), for: .touchUpInside)
        loadButton.addTarget(self, action: #selector(loadDiary), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(deleteDiary), for: .touchUpInside)

    }
    
    // UIのレイアウト設定
    func setupUI() {
        view.addSubview(datePicker)
        view.addSubview(textView)
        view.addSubview(saveButton)
        view.addSubview(loadButton)
        view.addSubview(resultLabel)
        view.addSubview(idTextField)
        view.addSubview(deleteButton)
        

        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            datePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            textView.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 20),
            textView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textView.widthAnchor.constraint(equalToConstant: 300),
            textView.heightAnchor.constraint(equalToConstant: 150),
            
            saveButton.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 20),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -70),
            
            loadButton.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 20),
            loadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 70),
            
            resultLabel.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 30),
            resultLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            resultLabel.widthAnchor.constraint(equalToConstant: 300),
            
            idTextField.topAnchor.constraint(equalTo: resultLabel.bottomAnchor, constant: 20),
            idTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            idTextField.widthAnchor.constraint(equalToConstant: 300),
            
            deleteButton.topAnchor.constraint(equalTo: idTextField.bottomAnchor, constant: 10),
            deleteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)

        ])
    }
    
    // 日記を保存する処理
    @objc func saveDiary() {
        let realm = try! Realm()
        let selectedDate = datePicker.date
        
        // プライマリキーがYYYYMMDD形式になるように設定
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd" // 固定フォーマット
        let id = dateFormatter.string(from: selectedDate)
        print(id) // 例: 20241129
        
        // データ作成または更新
        let entry = DiaryEntry()
        entry.id = id
        entry.date = selectedDate
        entry.content = textView.text
        
        try! realm.write {
            realm.add(entry, update: .modified)
        }
        
        resultLabel.text = "日記を保存しました！"
        textView.text = ""
    }
    
    // 日記を読み込む処理
    @objc func loadDiary() {
        let realm = try! Realm()
        let selectedDate = datePicker.date

        // 選択された日付の開始と終了時刻を取得
        let startOfDay = Calendar.current.startOfDay(for: selectedDate)
        let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)!

        // クエリで日付を範囲指定
        let predicate = NSPredicate(format: "date >= %@ AND date < %@", startOfDay as NSDate, endOfDay as NSDate)
        for entry in realm.objects(DiaryEntry.self).filter(predicate) {
            print("ID: \(entry.id), 日付: \(entry.date), 内容: \(entry.content)")
        }
        let entry = realm.objects(DiaryEntry.self).filter(predicate).first

        // 結果を表示
        if let entry = entry {
            resultLabel.text = "日記: \(entry.content)"
            idTextField.text = entry.id
        } else {
            resultLabel.text = "指定の日付に日記はありません"
        }
    }
    
    // 日記を削除する処理
    @objc func deleteDiary() {
        let realm = try! Realm()
        guard let id = idTextField.text, !id.isEmpty else {
            resultLabel.text = "IDを入力してください"
            return
        }
        
        // IDで削除対象を検索
        if let entry = realm.object(ofType: DiaryEntry.self, forPrimaryKey: id) {
            try! realm.write {
                realm.delete(entry)
            }
            resultLabel.text = "ID: \(id) の日記を削除しました"
            idTextField.text = ""
        } else {
            resultLabel.text = "ID: \(id) の日記は存在しません"
        }
    }
}
