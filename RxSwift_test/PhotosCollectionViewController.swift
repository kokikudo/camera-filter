//
//  PhotosCollectionViewController.swift
//  RxSwift_test
//
//  Created by kudo koki on 2022/03/16.
//

import UIKit
import Photos



class PhotosCollectionViewController: UICollectionViewController {

    private let reuseIdentifier = "Cell"

    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        populatePhotos()
    }

    private func populatePhotos() {

        PHPhotoLibrary.requestAuthorization { status in
            if status == .authorized {
                // アクセスを承認した時の処理
            }
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 0
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)

        return cell
    }


}
