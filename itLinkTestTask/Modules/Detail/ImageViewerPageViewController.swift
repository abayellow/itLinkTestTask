//
//  DetailViewController.swift
//  itLinkTestTask
//
//  Created by Alexander Abanshin on 18.11.2025.

import UIKit

final class ImageViewerPageViewController: UIPageViewController {
    private let urls: [URL]
    private var currentIndex: Int = 0
    private var isFullscreen = false {
        didSet { updateFullscreenUI() }
    }
    
    init(urls: [URL], startIndex: Int) {
        self.urls = urls
        self.currentIndex = startIndex
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
        modalPresentationStyle = .fullScreen
    }
    required init?(coder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        dataSource = self
        delegate = self
        
        setViewControllers([makeVC(index: currentIndex)], direction: .forward, animated: false)
        
        setupNavigationButtons()
    }
}

extension ImageViewerPageViewController {
    private func makeVC(index: Int) -> UIViewController {
        let viewContoller = SingleImageViewController(url: urls[index])
        viewContoller.index = index
        
        viewContoller.onTap = { [weak self] in
            self?.toggleFullscreen()
        }
        
        viewContoller.onSwipeDown = { [weak self] in
            self?.dismiss(animated: true)
        }
        
        return viewContoller
    }
}

extension ImageViewerPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let vc = viewController as? SingleImageViewController else { return nil }
        let newIndex = vc.index - 1
        return newIndex >= 0 ? makeVC(index: newIndex) : nil
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController)
                            -> UIViewController? {
        guard let vc = viewController as? SingleImageViewController else { return nil }
        let newIndex = vc.index + 1
        return newIndex < urls.count ? makeVC(index: newIndex) : nil
    }
}

extension ImageViewerPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        if completed,
           let vc = viewControllers?.first as? SingleImageViewController {
            currentIndex = vc.index
        }
    }
}


extension ImageViewerPageViewController {
    private func toggleFullscreen() {
        isFullscreen.toggle()
    }
    
    private func updateFullscreenUI() {
        let hide = isFullscreen
        
        navigationController?.setNavigationBarHidden(hide, animated: true)
        
        UIView.animate(withDuration: 0.2) {
            self.view.backgroundColor = .black
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    override var prefersStatusBarHidden: Bool { isFullscreen }
}

extension ImageViewerPageViewController {
    private func setupNavigationButtons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "✕",
            style: .plain,
            target: self,
            action: #selector(close)
        )
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self,
            action: #selector(share)
        )
    }
    
    @objc private func close() { dismiss(animated: true) }
    
    @objc private func share() {
        let ac = UIActivityViewController(activityItems: [urls[currentIndex]], applicationActivities: nil)
        present(ac, animated: true)
    }
}
