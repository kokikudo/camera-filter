import UIKit
import RxSwift
import RxCocoa

let disposeBug = DisposeBag()
// 発行されたイベントをサブスクライバーに送る役割を持つ
//let subject = PublishSubject<String>()
let subject = ReplaySubject<String>.create(bufferSize: 2)
// サブジェクトにイベントを発行
subject.onNext("Event 1")
// サブスクライブ前のイベントは送られない
// BehaviorSubjectの場合は初期値がこのイベントに更新されて送られる

// サブスクライブ
subject.subscribe { print($0) }

// サブスクライブ後に発行されたイベントはサブスクライバーに送られる
subject.onNext("Event 2")
subject.onNext("Event 3")

// dispose or complete になるとその後のイベントは送られない
subject.onCompleted()
subject.onNext("Event 4")


let subjectReplay = ReplaySubject<String>.create(bufferSize: 2)
subjectReplay.onNext("Event 1")
subjectReplay.onNext("Event 2")
subjectReplay.onNext("Event 3")
subjectReplay.subscribe { print("subjectReplay: ", $0) }
subjectReplay.onCompleted()
subjectReplay.onNext("Event 4")
subjectReplay.onNext("Event 5")
subjectReplay.onNext("Event 6")
subjectReplay.subscribe { print("subjectReplay2: ", $0) }


let relay = BehaviorRelay(value: "")
relay.accept("k")
relay.accept("ku")

relay.subscribe { print("BehaviorRelay: ", $0) }.disposed(by: disposeBug)
relay.accept("kud")
relay.accept("kudo")
