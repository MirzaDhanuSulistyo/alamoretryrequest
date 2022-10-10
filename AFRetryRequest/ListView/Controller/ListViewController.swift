//
//  ListViewController.swift
//  AFRetryRequest
//
//  Created by a.alami on 12/10/2020.
//  Copyright © 2020 Deep Minds. All rights reserved.
//

import UIKit
class ListViewController: UIViewController {
    lazy var viewModel: ListViewModel = {
        return ListViewModel()
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getData { (result) in
            switch result {
            case .success(let data):
                print("https://zenwel.indociti.com/api/admin/v1/id/myAccount/me\n")
                print("RESPONSE : \(String(data: data, encoding: .utf8) ?? "")")
            case .failure(let error):
                print(error)
            }
        }
    }
    @IBAction func refreshPressed(_ sender: UIButton) {
        viewModel.getData { (result) in
            switch result {
            case .success(let data):
                print("\nhttps://zenwel.indociti.com/api/admin/v1/id/myAccount/me\n")
                print("RESPONSE : \(String(data: data, encoding: .utf8) ?? "")")
            case .failure(let error):
                print(error)
            }
        }
        
        viewModel.getCustomer { (result) in
            switch result {
            case .success(let data):
                print("\nhttps://zenwel.indociti.com/api/admin/v1/id/staff\n")
                print("RESPONSE : \(String(data: data, encoding: .utf8) ?? "")")
            case .failure(let error):
                print(error)
            }
        }
    }
    @IBAction func logoutPressed(_ sender: UIButton) {
        viewModel.logout { (result) in
            switch result {
            case .success(let data):
                print("https://zenwel.indociti.com/api/admin/v1/id/oauth/logout\n")
                print("RESPONSE : \(String(data: data, encoding: .utf8) ?? "")")
            case .failure(let error):
                print(error)
            }
        }
    }
}
