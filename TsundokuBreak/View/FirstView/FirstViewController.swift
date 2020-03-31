//
//  FirstViewController.swift
//  TsundokuBreak
//
//  Created by Mizuki Kubota on 2020/03/23.
//  Copyright © 2020 MizukiKubota. All rights reserved.
//

import UIKit
import Moya

class FirstViewController: UIViewController {

    @IBAction func barcodeButtonTouchUp(_ sender: Any) {
        self.view.window?.rootViewController?.present(BarCodeReaderViewController.makeVC(), animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let provider = MoyaProvider<GoogleBooksAPIs>()

        //        provider.request(.search("isbn:9784873116594")) { result in
        provider.request(.search("isbn:9784478025819")) { result in
            switch result {
            case let .success(moyaResponse):
                do {
                    let data = try moyaResponse.mapJSON()
                    print(data)
                    let jsonData = try? JSONDecoder().decode(BookInfo.self, from: moyaResponse.data)
                    print(jsonData?.items?[0].volumeInfo?.title as Any)
                } catch {
                    print("json parse失敗")
                }
            case let .failure(error):
                print("アクセスに失敗しました:\(error)")
            }

        }

        /*
         // MARK: - Navigation

         // In a storyboard-based application, you will often want to do a little preparation before navigation
         override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
         }
         */
    }
}
