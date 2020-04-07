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

struct  BarCodeReaderModelInput {
    let isbnRelay: PublishRelay<String>
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
        input.isbnRelay
            .subscribe(onNext: { [weak self] isbn in
                guard let self = self else { return }
                self.getRequest(isbnNumber: isbn)
            })
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
        print(jsonData.totalItems!)
        print(jsonData.items?[0].volumeInfo?.imageLinks?.thumbnail as Any)
        print(jsonData.items?[0].volumeInfo?.title as Any)
        print(jsonData.items?[0].volumeInfo?.authors?[0] as Any)
        print(jsonData.items?[0].volumeInfo?.publishedDate as Any)
        print(jsonData.items?[0].volumeInfo?.pageCount as Any)

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
                    print("item ないよう")
                } else {
                    zeroRelay.accept(false)
                    print("item あるよう")
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
                authorRelay.accept(author)
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
                publicationRelay.accept(publication)
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
                pageCountRelay.accept(String(pageCount))
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
