//
//  StationDetailViewController.swift
//  SubwayStation
//
//  Created by UAPMobile on 2022/02/09.
//

import UIKit
import SnapKit
import Alamofire

class StationDetailViewController: UIViewController {
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        return refreshControl
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        //layout.estimatedItemSize = CGSize(width: view.frame.width - 32.0 , height: 100.0)
        layout.sectionInset = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.refreshControl = refreshControl
        collectionView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
        
        collectionView.register(StationDetailCollectionViewCell.self, forCellWithReuseIdentifier: "StationDetailCollectionViewCell")
        
        return collectionView
    }()

    @objc func handleRefreshControl() {
       // Update your content…

       // Dismiss the refresh control.
       DispatchQueue.main.async {
          self.collectionView.refreshControl?.endRefreshing()
       }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
}

extension StationDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StationDetailCollectionViewCell", for: indexPath) as? StationDetailCollectionViewCell else { return UICollectionViewCell() }
        return cell
    }
    
    
}

extension StationDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 10, height: 80)
    }
}

private extension StationDetailViewController {
    func setupViews() {
        navigationItem.title = "왕십리"
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func fetchData() {
        
    }
}
