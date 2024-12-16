//
//  MainViewController.swift
//  AlcoholPresetSampleApp
//
//  Created by Toshihiko Arai on 2024/12/12.
//

import UIKit

class MainViewController: UIViewController {

    var tableView: UITableView!
    var presets: [AlcoholPreset] = [
        AlcoholPreset(name: "ビール500缶", alcoholPercentage: 5.0, volume: 500),
        AlcoholPreset(name: "赤ワイン1杯", alcoholPercentage: 13.0, volume: 120),
        AlcoholPreset(name: "赤ワイン1本", alcoholPercentage: 13.0, volume: 720),
        AlcoholPreset(name: "日本酒1合", alcoholPercentage: 15.0, volume: 180),
        AlcoholPreset(name: "ウイスキーダブル1杯", alcoholPercentage: 43.0, volume: 60),
        AlcoholPreset(name: "ストロング 9% 500ml", alcoholPercentage: 9.0, volume: 500),
        AlcoholPreset(name: "缶チューハイ 7% 500ml", alcoholPercentage: 7.0, volume: 500),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavigationBar()
    }

    private func setupTableView() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "CustomCell")
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(tableView)
    }

    private func setupNavigationBar() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        let editButton = UIBarButtonItem(title: "並べ替え", style: .plain, target: self, action: #selector(toggleEditMode))
        navigationItem.rightBarButtonItems = [addButton, editButton]
    }

    private func showDetailViewController(for preset: AlcoholPreset?, index: Int?) {
        let detailVC = DetailViewController()
        detailVC.preset = preset
        detailVC.index = index
        detailVC.delegate = self
        navigationController?.pushViewController(detailVC, animated: true)
    }

    @objc private func addButtonTapped() {
        showDetailViewController(for: nil, index: nil)
    }

    @objc private func toggleEditMode() {
        tableView.setEditing(!tableView.isEditing, animated: true)
        navigationItem.rightBarButtonItems?[1].title = tableView.isEditing ? "完了" : "並べ替え"
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presets.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as? CustomTableViewCell else {
            return UITableViewCell()
        }
        let preset = presets[indexPath.row]
        cell.configure(name: preset.name, alcoholPercentage: preset.alcoholPercentage, volume: preset.volume, pureAlcohol: preset.pureAlcohol)
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            presets.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let preset = presets[indexPath.row]
        showDetailViewController(for: preset, index: indexPath.row)
    }

    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedPreset = presets.remove(at: sourceIndexPath.row)
        presets.insert(movedPreset, at: destinationIndexPath.row)
    }
}

extension MainViewController: DetailViewControllerDelegate {
    func didSavePreset(_ preset: AlcoholPreset, at index: Int?) {
        if let index = index {
            presets[index] = preset
        } else {
            presets.append(preset)
        }
        tableView.reloadData()
    }
}
