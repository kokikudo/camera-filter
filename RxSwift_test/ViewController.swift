//
//  ViewController.swift
//  RxSwift_test
//
//  Created by kudo koki on 2022/03/09.
//

import UIKit
import RxSwift

class ViewController: UIViewController {

    @IBOutlet weak var photoImageView: UIImageView!
    private let disposeBag = DisposeBag()


    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.prefersLargeTitles = true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // 遷移先を確認しsubscribeを設定する
        guard let navC = segue.destination as? UINavigationController,
              let photoCVC = navC.viewControllers.first as? PhotosCollectionViewController else {
                  fatalError("segueの承認失敗")
              }

        photoCVC.selectedImageSubject.subscribe(onNext: {[weak self] photo in
            self?.photoImageView.image = photo
        }).disposed(by: disposeBag)
    }
}

