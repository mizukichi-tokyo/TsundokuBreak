//
//  BarCodeReaderViewModelTest.swift
//  TsundokuBreakTests
//
//  Created by Mizuki Kubota on 2020/04/22.
//  Copyright © 2020 MizukiKubota. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa
import RxTest

@testable import TsundokuBreak

class BarCodeReaderViewModelTest: XCTestCase {
    var viewModel: BarCodeReaderViewModel!
    let scheduler = TestScheduler(initialClock: 0)

    final class MockBarcodeReaderModel: BarCodeReaderModelType, BarCodeReaderModelOutput {

        struct Dependency {}

        private let disposeBag = DisposeBag()

        var outputs: BarCodeReaderModelOutput?

        init(with dependency: Dependency,
             zero: TestableObservable<Bool>,
             url: TestableObservable<URL>,
             title: TestableObservable<String>,
             author: TestableObservable<String>,
             publication: TestableObservable<String>,
             pageCount: TestableObservable<String>
        ) {

            self.zeroItemRelay = PublishRelay<Bool>()
            self.urlRelay = PublishRelay<URL>()
            self.titleRelay = PublishRelay<String>()
            self.authorRelay = PublishRelay<String>()
            self.publicationRelay = PublishRelay<String>()
            self.pageCountRelay = PublishRelay<String>()

            zero.bind(to: self.zeroItemRelay).disposed(by: disposeBag)
            url.bind(to: self.urlRelay).disposed(by: disposeBag)
            title.bind(to: self.titleRelay).disposed(by: disposeBag)
            author.bind(to: self.authorRelay).disposed(by: disposeBag)
            publication.bind(to: self.publicationRelay).disposed(by: disposeBag)
            pageCount.bind(to: self.pageCountRelay).disposed(by: disposeBag)
            self.outputs = self

        }

        func setup(input: BarCodeReaderModelInput) {
            return
        }

        var zeroItemRelay: PublishRelay<Bool>
        var urlRelay: PublishRelay<URL>
        var titleRelay: PublishRelay<String>
        var authorRelay: PublishRelay<String>
        var publicationRelay: PublishRelay<String>
        var pageCountRelay: PublishRelay<String>

    }

    func testLordRecord() {
        let disposeBag = DisposeBag()
        let url = URL(string: "http://books.google.com/books/content?id=RhbBoAEACAAJ&printsec=frontcover&img=1&zoom=5&source=gbs_api")!

        let zeroTest = scheduler.createColdObservable([
            Recorded.next(50, true)
        ])
        let urlTest = scheduler.createColdObservable([
            Recorded.next(50, url)
        ])
        let titleTest = scheduler.createColdObservable([
            Recorded.next(50, "本のタイトル")
        ])
        let authorTest = scheduler.createColdObservable([
            Recorded.next(50, "本の著者")
        ])
        let publicationTest = scheduler.createColdObservable([
            Recorded.next(50, "2020-04-20")
        ])
        let pageCountTest = scheduler.createColdObservable([
            Recorded.next(50, "325")
        ])

        let dependency = MockBarcodeReaderModel(
            with: MockBarcodeReaderModel.Dependency.init(),
            zero: zeroTest,
            url: urlTest,
            title: titleTest,
            author: authorTest,
            publication: publicationTest,
            pageCount: pageCountTest
        )

        viewModel = BarCodeReaderViewModel(with: dependency)

        let zeroItemRelayModel = scheduler.createObserver(Bool.self)
        let urlItemRelayModel = scheduler.createObserver(URL.self)
        let titleItemRelayModel = scheduler.createObserver(String.self)
        let authorItemRelayModel = scheduler.createObserver(String.self)
        let publicationItemRelayModel = scheduler.createObserver(String.self)
        let pageCountItemRelayModel = scheduler.createObserver(String.self)

        viewModel.outputs?.zeroItemSignal.emit(to: zeroItemRelayModel).disposed(by: disposeBag)

        viewModel.outputs?.urlSignal
            .emit(to: urlItemRelayModel)
            .disposed(by: disposeBag)

        viewModel.outputs?.titleSignal
            .emit(to: titleItemRelayModel)
            .disposed(by: disposeBag)

        viewModel.outputs?.authorSignal
            .emit(to: authorItemRelayModel)
            .disposed(by: disposeBag)

        viewModel.outputs?.publicationSignal
            .emit(to: publicationItemRelayModel)
            .disposed(by: disposeBag)

        viewModel.outputs?.pageCountSignal
            .emit(to: pageCountItemRelayModel)
            .disposed(by: disposeBag)

        scheduler.start()

        // 想定されるテスト結果の定義
        let expectedZero = true
        let expectedUrl = url
        let expectedTitle = "本のタイトル"
        let expectedAuthor = "本の著者"
        let expectedPublication = "2020-04-20"
        let expectedPageCount = "325"

        // 実際の実行結果
        let elementZero = zeroItemRelayModel.events.first!.value.element
        let elementUrl = urlItemRelayModel.events.first!.value.element
        let elementTitle = titleItemRelayModel.events.first!.value.element
        let elementAuthor = authorItemRelayModel.events.first!.value.element
        let elementPublication = publicationItemRelayModel.events.first!.value.element
        let elementPageCount = pageCountItemRelayModel.events.first!.value.element

        // 想定結果と実行結果の比較
        XCTAssertEqual(elementZero, expectedZero)
        XCTAssertEqual(elementUrl, expectedUrl)
        XCTAssertEqual(elementTitle, expectedTitle)
        XCTAssertEqual(elementAuthor, expectedAuthor)
        XCTAssertEqual(elementPublication, expectedPublication)
        XCTAssertEqual(elementPageCount, expectedPageCount)
    }
}
