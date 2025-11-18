//
//  CacheManager.swift
//  itLinkTestTask
//
//  Created by Alexander Abanshin on 17.11.2025.
//

import UIKit
import CryptoKit

final class CacheManager {
    static let shared = CacheManager()
    private let cache = NSCache<NSString, UIImage>()
    private let fileManager = FileManager.default
    private let diskCacheURL: URL

    private init() {
        let urls = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)
        let cacheDir = urls[0].appendingPathComponent("ImageCache", isDirectory: true)
        if !fileManager.fileExists(atPath: cacheDir.path) {
            try? fileManager.createDirectory(at: cacheDir, withIntermediateDirectories: true)
        }
        diskCacheURL = cacheDir
    }

    func save(image: UIImage, for url: URL) {
        let key = url.absoluteString as NSString
        cache.setObject(image, forKey: key)

        let fileURL = diskCacheURL.appendingPathComponent(hashedFileName(url))
        if let data = image.pngData() {
            try? data.write(to: fileURL)
        }
    }

    func image(for url: URL) -> UIImage? {
        let key = url.absoluteString as NSString
        
        if let cached = cache.object(forKey: key) {
            return cached
        }
        
        let fileURL = diskCacheURL.appendingPathComponent(hashedFileName(url))
        if let data = try? Data(contentsOf: fileURL),
           let image = UIImage(data: data) {
            cache.setObject(image, forKey: key)
            return image
        }
        return nil
    }

    private func hashedFileName(_ url: URL) -> String {
        let digest = SHA256.hash(data: Data(url.absoluteString.utf8))
        return digest.compactMap { String(format: "%02x", $0) }.joined() + ".png"
    }
}
