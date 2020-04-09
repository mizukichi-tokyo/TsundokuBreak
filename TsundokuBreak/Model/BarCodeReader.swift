//
//  BarCodeReader.swift
//  BarCodeReaderBreak
//
//  Created by Mizuki Kubota on 2020/03/31.
//  Copyright © 2020 MizukiKubota. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Moya
import Realm
import RxRealm
import RealmSwift

struct  BarCodeReaderModelInput {
    let isbnRelay: PublishRelay<String>
    let addButton: ControlEvent<Void>
}

protocol  BarCodeReaderModelOutput {
    var zeroItemRelay: PublishRelay<Bool> { get }
    var urlRelay: PublishRelay<URL> { get }
    var titleRelay: PublishRelay<String> { get }
    var authorRelay: PublishRelay<String> { get }
    var publicationRelay: PublishRelay<String> { get }
    var pageCountRelay: PublishRelay<String> { get }
}

protocol BarCodeReaderModelType {
    var outputs: BarCodeReaderModelOutput? { get }
    func setup(input: BarCodeReaderModelInput)
}

final class  BarCodeReaderModel: BarCodeReaderModelType, Injectable {
    struct Dependency {}

    var outputs: BarCodeReaderModelOutput?

    private let disposeBag = DisposeBag()
    private let provider = MoyaProvider<GoogleBooksAPIs>()
    private let bookInfo: PublishRelay<BookInfo>
    private var thumbnailUrl: String?
    private var title: String?
    private var author: String?
    private var publication: String?
    private var pageCount: Int?

    init(with dependency: Dependency) {
        self.bookInfo = PublishRelay<BookInfo>()
        self.outputs = self
    }

    func setup(input: BarCodeReaderModelInput) {
        let realm = self.createRealm()
        print(Realm.Configuration.defaultConfiguration.fileURL!)

        input.isbnRelay
            .subscribe(onNext: { [weak self] isbn in
                guard let self = self else { return }
                self.getRequest(isbnNumber: isbn)
            })
            .disposed(by: disposeBag)

        input.addButton
            .map { self.makeRecord() }
            .bind(to: realm.rx.add(onError: { elements, error in
                if let elements = elements {
                    print("Error \(error.localizedDescription) while saving objects \(String(describing: elements))")
                } else {
                    print("Error \(error.localizedDescription) while opening realm.")
                }
            }))
            .disposed(by: disposeBag)

    }
}

extension BarCodeReaderModel {
    private func getRequest(isbnNumber: String) {
        var isbnString: String = "isbn:"
        isbnString += isbnNumber

        provider.request(.search( isbnString )) { result in
            switch result {
            case let .success(moyaResponse):
                do {
                    let jsonData = try JSONDecoder().decode(BookInfo.self, from: moyaResponse.data)
                    self.processJsonData(jsonData: jsonData)

                } catch {
                    print("json parse失敗")
                }
            case let .failure(error):
                print("アクセスに失敗しました:\(error)")
            }

        }
    }

    private func processJsonData(jsonData: BookInfo) {
        self.bookInfo.accept(jsonData)
        //        print(jsonData.totalItems!)
        //        print(jsonData.items?[0].volumeInfo?.imageLinks?.thumbnail as Any)
        //        print(jsonData.items?[0].volumeInfo?.title as Any)
        //        print(jsonData.items?[0].volumeInfo?.authors?[0] as Any)
        //        print(jsonData.items?[0].volumeInfo?.publishedDate as Any)
        //        print(jsonData.items?[0].volumeInfo?.pageCount as Any)

    }

    private func makeRecord() -> Record {
        let record = Record()
        record.thumbnailUrl = thumbnailUrl!
        record.title = title!
        record.author = author!
        record.publication = publication!
        record.pageCount = pageCount!
        return record
    }

}

extension BarCodeReaderModel: BarCodeReaderModelOutput {
    var zeroItemRelay: PublishRelay<Bool> {
        let zeroRelay = PublishRelay<Bool>()

        self.bookInfo
            .subscribe(onNext: { info in
                let itemCount = info.totalItems!
                if itemCount == 0 {
                    zeroRelay.accept(true)
                } else {
                    zeroRelay.accept(false)
                }
            })
            .disposed(by: disposeBag)

        return zeroRelay
    }

    var titleRelay: PublishRelay<String> {
        let titleRelay =  PublishRelay<String>()

        self.bookInfo
            .subscribe(onNext: { info in
                let titleString = info.items?[0].volumeInfo?.title
                guard let title = titleString else {return}
                titleRelay.accept(title)
                self.title = title
            })
            .disposed(by: disposeBag)

        return titleRelay

    }

    var authorRelay: PublishRelay<String> {
        let authorRelay =  PublishRelay<String>()

        self.bookInfo
            .subscribe(onNext: { info in
                let authorString = info.items?[0].volumeInfo?.authors?[0]
                guard let author = authorString else {return}
                authorRelay.accept("著者: " + author)
                self.author = author
            })
            .disposed(by: disposeBag)

        return authorRelay

    }

    var publicationRelay: PublishRelay<String> {
        let publicationRelay =  PublishRelay<String>()

        self.bookInfo
            .subscribe(onNext: { info in
                let publicationString = info.items?[0].volumeInfo?.publishedDate
                guard let publication = publicationString else {return}
                publicationRelay.accept("出版日: " + publication)
                self.publication = publication
            })
            .disposed(by: disposeBag)

        return publicationRelay

    }

    var pageCountRelay: PublishRelay<String> {
        let pageCountRelay =  PublishRelay<String>()

        self.bookInfo
            .subscribe(onNext: { info in
                let pageCountString = info.items?[0].volumeInfo?.pageCount
                guard let pageCount = pageCountString else {return}
                pageCountRelay.accept("ページ数: " + String(pageCount))
                self.pageCount = pageCount
            })
            .disposed(by: disposeBag)

        return pageCountRelay

    }

    var urlRelay: PublishRelay<URL> {
        let urlRelay =  PublishRelay<URL>()

        self.bookInfo
            .subscribe(onNext: { info in
                let urlString = info.items?[0].volumeInfo?.imageLinks?.thumbnail
                guard var url = urlString else {return}
                url = "https" + url.dropFirst(4)
                urlRelay.accept(URL(string: url)!)
                self.thumbnailUrl = url
            })
            .disposed(by: disposeBag)

        return urlRelay
    }
}

extension BarCodeReaderModel {
    private func createRealm() -> Realm {
        do {
            return try Realm()
        } catch let error as NSError {
            assertionFailure("realm error: \(error)")
            let config = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
            // swiftlint:disable:next force_try
            return try! Realm(configuration: config)
            // swiftlint:disable:previous force_try
        }
    }
}
