//
//  CalendarPageViewController.swift
//  dansyu
//
//  Created by Toshihiko Arai on 2024/11/24.
//

import UIKit

class CalendarPageViewController: UIViewController {
    private let calendar = Calendar.current
    private var currentMonth: Date = Date()
    private var pageViewController: UIPageViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupPageViewController()
    }

    private func setupPageViewController() {
        // UIPageViewControllerを初期化
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.dataSource = self
        pageViewController.delegate = self

        // 初期ページを設定
        let initialVC = CalendarMonthViewController()
        initialVC.setMonth(date: currentMonth)
        pageViewController.setViewControllers([initialVC], direction: .forward, animated: false, completion: nil)

        // ページビューを親ビューに追加
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)

        // レイアウト設定
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pageViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            pageViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

}

extension CalendarPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentVC = viewController as? CalendarMonthViewController else { return nil }
        guard let previousMonth = calendar.date(byAdding: .month, value: -1, to: currentVC.currentMonth) else { return nil }

        let previousVC = CalendarMonthViewController()
        previousVC.setMonth(date: previousMonth)
        return previousVC
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentVC = viewController as? CalendarMonthViewController else { return nil }
        guard let nextMonth = calendar.date(byAdding: .month, value: 1, to: currentVC.currentMonth) else { return nil }

        let nextVC = CalendarMonthViewController()
        nextVC.setMonth(date: nextMonth)
        return nextVC
    }
}

extension CalendarPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed, let currentVC = pageViewController.viewControllers?.first as? CalendarMonthViewController {
            self.currentMonth = currentVC.currentMonth
        }
    }
}

