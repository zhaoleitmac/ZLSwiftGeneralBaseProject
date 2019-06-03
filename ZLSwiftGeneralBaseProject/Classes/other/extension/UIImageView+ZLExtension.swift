//
//  UIImageView+ZLExtension.swift
//  YFCB
//
//  Created by 赵雷 on 2018/12/9.
//  Copyright © 2018 缀新网络技术有限公司. All rights reserved.
//

import UIKit
import AVFoundation

extension ZLExtension where Base: UIImageView {
    
    func setImage(videoUrl: String?, placeholder: UIImage? = nil) {
        let imageView = self.base
        imageView.image = placeholder
        if let videoUrl = videoUrl, let url = URL(string: videoUrl) {
            DispatchQueue.global().async {
                if let image = Base.zl.getImage(videoUrl: url) {
                    DispatchQueue.main.async {
                        imageView.image = image
                    }
                }
            }
        }
    }
    
}

extension ZLExtension {
    ///获取视频第一桢图片
    class func getImage(videoUrl: URL) -> UIImage? {
        let asset = AVURLAsset(url: videoUrl, options: nil)
        let assetGen = AVAssetImageGenerator(asset: asset)
        
        assetGen.appliesPreferredTrackTransform = true
        let time: CMTime = CMTimeMakeWithSeconds(0.0, preferredTimescale: 600)
        var _: Error? = nil
        var actualTime = CMTime()
        do {
            let image = try assetGen.copyCGImage(at: time, actualTime: &actualTime)
            let videoImage = UIImage(cgImage: image)
            return videoImage
        } catch {
            return nil
        }
    }
}
