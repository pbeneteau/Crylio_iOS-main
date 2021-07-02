//
//  ImageUtils.swift
//  Crylio_v2
//
//  Created by Paul Bénéteau on 21/05/2021.
//

import Foundation
import UIKit
import Kingfisher


extension UIImageView {
    
    func setImage(from url: String) {
        
        ImageCache.default.memoryStorage.config.totalCostLimit = 1
        
        if ImageCache.default.isCached(forKey: url) {
            getCachedImage(with: url) { result in
                if let image = result {
                    self.image = image
                } else {
                    self.loadImage(from: url) { result in
                        if let image = result {
                            self.image = image
                        }
                    }
                }
            }
        } else {
            self.loadImage(from: url) { result in
                if let image = result {
                    self.image = image
                }
            }
        }
    }
    
    func loadImage(from url: String, completion: @escaping(UIImage?) -> Void) {
        
        let URL = URL(string: url)
        let processor = DefaultImageProcessor()
        
        self.kf.indicatorType = .activity
        
        self.kf.setImage(
            with: URL,
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(0.3)),
                .cacheOriginalImage
            ])
        {
            result in
            switch result {
            case .success(let result):
                ImageCache.default.store(result.image, forKey: url)
                completion(result.image)
            case .failure(let error):
                print(#function, ": Error Downloading image: \(error.localizedDescription) for " + self.debugDescription)
                completion(nil)
            }
        }
    }
    
}

func getCachedImage(with url: String, completion: @escaping(UIImage?) -> Void) {
    
    if ImageCache.default.isCached(forKey: url) {
        
        ImageCache.default.retrieveImage(forKey: url) { result in
            switch result {
            case .success(let value):
                switch value {
                case .none:
                    completion(nil)
                case .disk:
                    if let image = value.image {
                        completion(image)
                    } else {
                        completion(nil)
                    }
                case .memory:
                    if let image = value.image {
                        completion(image)
                    } else {
                        completion(nil)
                    }
                }
            case .failure(let error):
                print(#function, ": Error getting image: \(error.localizedDescription)")
                completion(nil)
            }
        }
    } else {
        print(false)
        completion(nil)
    }
}
