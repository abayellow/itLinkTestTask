//
//  SingleImageViewController.swift
//  itLinkTestTask
//
//  Created by Alexander Abanshin on 18.11.2025.
//

import  UIKit

final class SingleImageViewController: UIViewController {
    let url: URL
    var index: Int = 0
    
    var onTap: (() -> Void)?
    var onSwipeDown: (() -> Void)?
    
    private let scroll = UIScrollView()
    private let imageView = UIImageView()
    
    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError() }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        setupScroll()
        setupImage()
        loadImage()
        addGestures()
    }
    
    private func setupScroll() {
        scroll.frame = view.bounds
        scroll.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        scroll.minimumZoomScale = 1
        scroll.maximumZoomScale = 4
        scroll.delegate = self
        view.addSubview(scroll)
    }
    
    private func setupImage() {
        imageView.frame = scroll.bounds
        imageView.contentMode = .scaleAspectFit
        scroll.addSubview(imageView)
    }
    
    private func loadImage() {
        imageView.setImage(url: url)
    }
    
    private func addGestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tap)
        
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeDown))
        swipe.direction = .down
        view.addGestureRecognizer(swipe)
    }
    
    @objc private func handleTap() {
        onTap?()
    }
    
    @objc private func handleSwipeDown() {
        onSwipeDown?()
    }
}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? { imageView }
}
