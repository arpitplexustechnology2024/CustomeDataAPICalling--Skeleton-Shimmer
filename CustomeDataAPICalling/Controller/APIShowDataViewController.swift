//
//  APIShowDataViewController.swift
//  CustomeDataAPICalling
//
//  Created by Arpit iOS Dev. on 06/06/24.
//

import UIKit
import Alamofire
import SDWebImage

class APIShowDataViewController: UIViewController  {
    
    @IBOutlet weak var tableView: UITableView!
    
    var noInternetView: NoInternetView!
    var noDataView: NoDataView!
    var query: String?
    var items: [Item] = []
    var isLoading = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AvatarSkeletonTableViewCell.self, forCellReuseIdentifier: "AvatarSkeletonCell")
        
        setupNoInternetView()
        setupNoDataView()
        
        if let query = query {
            if isConnectedToInternet() {
                fetchData(query: query)
            } else {
                showNoInternetView()
            }
        }
    }
    
    func setupNoInternetView() {
        noInternetView = NoInternetView()
        noInternetView.translatesAutoresizingMaskIntoConstraints = false
        noInternetView.retryButton.addTarget(self, action: #selector(retryButtonTapped), for: .touchUpInside)
        view.addSubview(noInternetView)
        
        NSLayoutConstraint.activate([
            noInternetView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            noInternetView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            noInternetView.topAnchor.constraint(equalTo: view.topAnchor),
            noInternetView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        noInternetView.isHidden = true
    }
    
    func setupNoDataView() {
        noDataView = NoDataView()
        noDataView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(noDataView)
        
        NSLayoutConstraint.activate([
            noDataView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            noDataView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            noDataView.topAnchor.constraint(equalTo: view.topAnchor),
            noDataView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        noDataView.isHidden = true
    }
    
    @objc func retryButtonTapped() {
        if isConnectedToInternet() {
            noInternetView.isHidden = true
            fetchData(query: query!)
        } else {
            showAlert(title: "No Internet", message: "Please check your internet connection and try again.")
        }
    }
    
    func fetchData(query: String) {
        showSkeletonLoader()
        searchGitHubUsers(query: query) { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.hideSkeletonLoader()
                if self.items.isEmpty {
                    self.showNoDataView()
                } else {
                    self.noDataView.isHidden = true
                    self.tableView.isHidden = false
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func searchGitHubUsers(query: String, completion: @escaping () -> Void) {
        let url = "https://api.github.com/search/users"
        let parameters: [String: Any] = [
            "q": query
        ]
        
        AF.request(url, method: .get, parameters: parameters).responseDecodable(of: Welcome.self) { response in
            switch response.result {
            case .success(let searchResponse):
                self.items = searchResponse.items
                completion()
            case .failure(let error):
                print("Error occurred: \(error)")
                self.showAlert(title: "Error", message: "Failed to fetch data.")
                completion()
            }
        }
    }
    
    func showSkeletonLoader() {
        isLoading = true
        tableView.reloadData()
    }
    
    func hideSkeletonLoader() {
        isLoading = false
        tableView.reloadData()
    }
    
    func showNoDataView() {
        noDataView.isHidden = false
        tableView.isHidden = true
    }
    
    func showNoInternetView() {
        DispatchQueue.main.async {
            self.noInternetView.isHidden = false
        }
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    func isConnectedToInternet() -> Bool {
        let networkManager = NetworkReachabilityManager()
        return networkManager?.isReachable ?? false
    }
}

// MARK: - TableView Dalegate & Datasource
extension APIShowDataViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isLoading ? 4 : items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isLoading {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AvatarSkeletonCell", for: indexPath) as! AvatarSkeletonTableViewCell
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as? TableViewCell else {
                return UITableViewCell()
            }
            let item = items[indexPath.row]
            cell.avtarImageView.sd_setImage(with: URL(string: item.avatarURL), completed: nil)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 173
    }
    
}
