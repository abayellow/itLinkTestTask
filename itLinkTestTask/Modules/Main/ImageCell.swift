//
//  ImageCell.swift
//  itLinkTestTask
//
//  Created by Alexander Abanshin on 15.11.2025.
//

import UIKit

final class ImageCell: UICollectionViewCell {
    private let cellImageView = UIImageView()
    private let spinner = UIActivityIndicatorView(style: .medium)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(url: URL) {
        cellImageView.image = nil
        spinner.startAnimating()
        cellImageView.setImage(url: url, placeholder: nil) { [weak self] in
            guard let self = self else { return }
            self.spinner.stopAnimating()
            if self.cellImageView.image == nil {
                self.cellImageView.image = UIImage(named: "photo")
            }
        }
    }
}


private extension ImageCell {
    func setupViews() {
        cellImageView.translatesAutoresizingMaskIntoConstraints = false
        cellImageView.contentMode = .scaleAspectFill
        cellImageView.clipsToBounds = true
        addSubview(cellImageView)
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(spinner)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            cellImageView.topAnchor.constraint(equalTo: topAnchor),
            cellImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            cellImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            cellImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            spinner.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
