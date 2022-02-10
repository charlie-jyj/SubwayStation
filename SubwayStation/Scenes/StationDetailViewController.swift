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
    private let station: Station
    private var realtimeArrivalList: [StationArrivalDataResponseModel.RealTimeArrival] = []
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        return refreshControl
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        //layout.estimatedItemSize = CGSize(width: view.frame.width, height: 100.0)
        layout.sectionInset = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.refreshControl = refreshControl
        collectionView.refreshControl?.addTarget(self, action: #selector(fetchDetailData), for: .valueChanged)
        
        collectionView.register(StationDetailCollectionViewCell.self, forCellWithReuseIdentifier: "StationDetailCollectionViewCell")
        
        return collectionView
    }()
    
    init(station: Station) {
        self.station = station
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        fetchDetailData()
    }
}

extension StationDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 32.0, height: 100)
    }
}

extension StationDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return realtimeArrivalList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StationDetailCollectionViewCell", for: indexPath) as? StationDetailCollectionViewCell else { return UICollectionViewCell() }
        cell.setupViews(with: realtimeArrivalList[indexPath.row])
        return cell
    }
}

private extension StationDetailViewController {
    func setupViews() {
        navigationItem.title = self.station.stationName
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    @objc func fetchDetailData() {
        let stationName = validateStationName(stationName: self.station.stationName)
        let urlString = "http://swopenapi.seoul.go.kr/api/subway/sample/json/realtimeStationArrival/0/5/\(stationName)"
        AF.request(urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
            .responseDecodable(of: StationArrivalDataResponseModel.self) {
                [weak self]
                response in
                guard let self = self,
                    case .success(let data) = response.result
                       else { return }
                self.realtimeArrivalList = data.realtimeArrivalList
                self.collectionView.reloadData()
                
                DispatchQueue.main.async {
                    self.refreshControl.endRefreshing()
                }
            }
    }
    
    
    func validateStationName(stationName: String) -> String {
        var index = -1;
        return Array(stationName).compactMap {
            index += 1
            if $0 == "역", index != 0 {
                return nil
            }
            return String($0)
        }
        .joined(separator: "")
    }
}
