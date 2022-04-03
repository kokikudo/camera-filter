//
//  PhotosCollectionViewController.swift
//  RxSwift_test
//
//  Created by kudo koki on 2022/03/16.
//

import UIKit
import Photos
import RxSwift

class PhotosCollectionViewController: UICollectionViewController {

    private let reuseIdentifier = "PhotoCollectionViewCell"
    private var images = [PHAsset]() // 読み込んだ画像を格納する変数
    // 読み込んだ画像を購読するためのSubject
    let selectedImageSubject = PublishSubject<UIImage>()
    // なぜかSubjectをasObservableでObservable型に変換
    var photoImageObservable: Observable<UIImage> {
        return selectedImageSubject.asObservable()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        populatePhotos()
    }

    private func populatePhotos() {

        PHPhotoLibrary.requestAuthorization { [weak self] status in
            if status == .authorized {
                // アクセスを承認した時の処理

                let asset = PHAsset.fetchAssets(with: .image, options: nil)

                asset.enumerateObjects { (object, count, stop) in
                    self?.images.append(object)
                }

                self?.images.reverse()
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }

            }
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedAsset = self.images[indexPath.row]
        // PHImageManagerで画像を読み込む
        PHImageManager.default().requestImage(for: selectedAsset, targetSize: CGSize(width: 300, height: 300), contentMode: .aspectFit, options: nil){ [weak self] image, info in
            guard let info = info else { return }
            // 画像が劣化してるか確認
            let isDegradedImage = info["PHImageResultIsDegradedKey"] as! Bool

            if !isDegradedImage {
                if let image = image {
                    // subjectへイベントを発行
                    self?.selectedImageSubject.onNext(image)
                    self?.dismiss(animated: true)
                }
            }
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? PhotoCollectionViewCell else {
            fatalError("CellのIDが間違っています")
        }

        let asset = self.images[indexPath.row]
        let manager = PHImageManager.default()

        manager.requestImage(for: asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFit, options: nil) { image, _ in
            DispatchQueue.main.async {
                cell.imageView.image = image
            }
        }

        return cell
    }


}
