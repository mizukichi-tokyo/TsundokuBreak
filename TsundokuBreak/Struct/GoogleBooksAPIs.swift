//
//  GoogleBooksAPIs.swift
//  TsundokuBreak
//
//  Created by Mizuki Kubota on 2020/03/24.
//  Copyright © 2020 MizukiKubota. All rights reserved.
//

import Foundation
import Moya

enum GoogleBooksAPIs {
    case search(String)
}
extension GoogleBooksAPIs: TargetType {
    var baseURL: URL {
        return URL(string: "https://www.googleapis.com/books/v1")!
    }

    var path: String {
        switch self {
        case .search:
            return "/volumes"
        }
    }

    var method: Moya.Method {
        return .get
    }

    var sampleData: Data {
        return APITestData.data(using: .utf8)!
    }

    var task: Task {
        switch self {
        case .search(let query):
            return .requestParameters(parameters: ["q": query], encoding: URLEncoding.default)
        }
    }

    var headers: [String: String]? {
        return nil
    }

}

let APITestData = """
{
"kind": "books#volumes",
"totalItems": 1,
"items": [
{
"kind": "books#volume",g
"id": "RhbBoAEACAAJ",
"etag": "yXGiAe/R9mQ",
"selfLink": "https://www.googleapis.com/books/v1/volumes/RhbBoAEACAAJ",
"volumeInfo": {
"title": "マイクロインタラクション",
"subtitle": "UI/UXデザインの神が宿る細部",
"authors": [
"Dan Saffer"
],
"publishedDate": "2014-03-20",
"description": "マイクロインタラクションの概念を提唱する書籍",
"industryIdentifiers": [
{
"type": "ISBN_10",
"identifier": "4873116597"
},
{
"type": "ISBN_13",
"identifier": "9784873116594"
}
],
"readingModes": {
"text": false,
"image": false
},
"pageCount": 217,
"printType": "BOOK",
"maturityRating": "NOT_MATURE",
"allowAnonLogging": false,
"contentVersion": "preview-1.0.0",
"imageLinks": {
"smallThumbnail": "http://books.google.com/books/content?id=RhbBoAEACAAJ&printsec=frontcover&img=1&zoom=5&source=gbs_api",
"thumbnail": "http://books.google.com/books/content?id=RhbBoAEACAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api"
},
"language": "ja",
"previewLink": "http://books.google.co.jp/books?id=RhbBoAEACAAJ&dq=isbn:9784873116594&hl=&cd=1&source=gbs_api",
"infoLink": "http://books.google.co.jp/books?id=RhbBoAEACAAJ&dq=isbn:9784873116594&hl=&source=gbs_api",
"canonicalVolumeLink": "https://books.google.com/books/about/%E3%83%9E%E3%82%A4%E3%82%AF%E3%83%AD%E3%82%A4%E3%83%B3%E3%82%BF%E3%83%A9%E3%82%AF%E3%82%B7%E3%83%A7%E3%83%B3.html?hl=&id=RhbBoAEACAAJ"
},
"saleInfo": {
"country": "JP",
"saleability": "NOT_FOR_SALE",
"isEbook": false
},
"accessInfo": {
"country": "JP",
"viewability": "NO_PAGES",
"embeddable": false,
"publicDomain": false,
"textToSpeechPermission": "ALLOWED",
"epub": {
"isAvailable": false
},
"pdf": {
"isAvailable": false
},
"webReaderLink": "http://play.google.com/books/reader?id=RhbBoAEACAAJ&hl=&printsec=frontcover&source=gbs_api",
"accessViewStatus": "NONE",
"quoteSharingAllowed": false
},
"searchInfo": {
"textSnippet": "マイクロインタラクションの概念を提唱する書籍"
}
}
]
}
"""
