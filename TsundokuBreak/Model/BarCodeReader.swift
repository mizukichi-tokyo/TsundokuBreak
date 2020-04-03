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
}

protocol BarCodeReaderModelType {
    var outputs: BarCodeReaderModelOutput? { get }
    func setup(input: BarCodeReaderModelInput)
}

final class  BarCodeReaderModel: BarCodeReaderModelType, Injectable, BarCodeReaderModelOutput {
    struct Dependency {}

    var outputs: BarCodeReaderModelOutput?

    private let disposeBag = DisposeBag()
    private let provider = MoyaProvider<GoogleBooksAPIs>()

    init(with dependency: Dependency) {
        self.outputs = self
    }

    func setup(input: BarCodeReaderModelInput) {
        input.isbnRelay.subscribe(onNext: { [weak self] isbn in
            guard let self = self else { return }
            self.getRequest(isbnNumber: isbn)
        }).disposed(by: disposeBag)

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
                    //                    let data = try moyaResponse.mapJSON()
                    //                    print(data)
                    let jsonData = try JSONDecoder().decode(BookInfo.self, from: moyaResponse.data)
                    print(jsonData.items?[0].volumeInfo?.imageLinks?.thumbnail as Any)
                    print(jsonData.items?[0].volumeInfo?.title as Any)
                    print(jsonData.items?[0].volumeInfo?.authors?[0] as Any)
                    print(jsonData.items?[0].volumeInfo?.publishedDate as Any)
                    print(jsonData.items?[0].volumeInfo?.pageCount as Any)

                } catch {
                    print("json parse失敗")
                }
            case let .failure(error):
                print("アクセスに失敗しました:\(error)")
            }

        }
    }
}
