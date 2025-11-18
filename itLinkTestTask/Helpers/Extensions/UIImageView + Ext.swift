//
//  UIImageView + Ext.swift
//  itLinkTestTask
//
//  Created by Alexander Abanshin on 17.11.2025.
//

 import UIKit


extension UIImageView {
    func setImage(url: URL, placeholder: UIImage? = nil, completion: (() -> Void)? = nil) {
        if let cached = CacheManager.shared.image(for: url) {
            self.image = cached
            completion?()
            return
        }
        Task {
            do {
                let image = try await loadImage(for: url)
                DispatchQueue.main.async {
                    UIView.transition(with: self,
                                      duration: 0.3,
                                      options: .transitionCrossDissolve,
                                      animations: { self.image = image },
                                      completion: { _ in completion?() })
                    CacheManager.shared.save(image: image, for: url)
                }
            } catch {
                print(error.localizedDescription)
                DispatchQueue.main.async { completion?() }
            }
        }
    }
    
    func loadImage(for url: URL) async throws -> UIImage {
        let request = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        guard let image = UIImage(data: data) else {
            throw URLError(.cannotDecodeContentData)
        }
        return image
    }
}
