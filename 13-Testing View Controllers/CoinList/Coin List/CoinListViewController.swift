//
//  CoinListViewController.swift
//  CoinList
//
//  Created by Ben Scheirman on 4/30/18.
//  Copyright © 2018 Fickle Bits, LLC. All rights reserved.
//

import UIKit

final class CoinListViewController : UITableViewController, StoryboardInitializable {
    
    var cryptoCompareClient: CryptoCompareClient = CryptoCompareClient(session: URLSession.shared)
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        indicator.hidesWhenStopped = true
        
        indicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(indicator)
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
        
        return indicator
    }()
    
    var coins: [Coin] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.startAnimating()
        cryptoCompareClient.fetchCoinList { result in
            self.activityIndicator.stopAnimating()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
}
