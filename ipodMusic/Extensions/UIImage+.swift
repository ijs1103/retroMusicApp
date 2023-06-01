//
//  UIImage+.swift
//  ipodMusic
//
//  Created by 이주상 on 2023/06/01.
//

import UIKit

extension UIImage {
    func imageToURL() -> URL? {
        var url: URL? = nil
        // Convert to Data
        if let data = self.pngData() {
            // Create URL
            let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            url = documents.appendingPathComponent("album_image.png")
            if FileManager.default.fileExists(atPath: url!.path) {
                // 이미지가 존재한다면 기존 경로에 있는 이미지 삭제
                do {
                    try FileManager.default.removeItem(at: url!)
                    print("이미지 삭제 완료")
                } catch {
                    print("이미지를 삭제하지 못하였습니다.")
                    return nil
                }
            }
            do {
                // Write to Disk
                try data.write(to: url!)
            } catch {
                print("이미지를 저장하지 못하였습니다.")
                return nil
            }
        }
        return url
    }
}
