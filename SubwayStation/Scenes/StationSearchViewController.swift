//
//  StationSearchViewController.swift
//  SubwayStation
//
//  Created by UAPMobile on 2022/02/09.
//

import UIKit
import SnapKit
import Alamofire

class StationSearchViewController: UIViewController {
    private var stations: [Station] = []
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationItems()
        setTableViewLayout()
    }
    
    private func setNavigationItems() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "지하철 도착 정보"
        
        let searchController = UISearchController()
        searchController.searchBar.placeholder = "지하철 역을 입력해주세요."
        searchController.obscuresBackgroundDuringPresentation = false // 자동 검색 UITableView를 선명하게 표시
        searchController.searchBar.delegate = self
        
        navigationItem.searchController = searchController
    }
    
    private func setTableViewLayout() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
        tableView.isHidden = true
    }
    
    private func requestStationName(from stationName: String) {
        let stationName = validateStationName(stationName: stationName)
        print("입력:\(stationName)")
        let urlString = "http://openapi.seoul.go.kr:8088/sample/json/SearchInfoBySubwayNameService/1/5/\(stationName)"
        
        AF.request(urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
            .responseDecodable(of: StationResponseModel.self) {
                [weak self]
                response in
                guard let self = self,
                    case .success(let data) = response.result
                       else { return }
                
                let nameset:[String] = Array(Set(data.stations.map {
                    return $0.stationName
                }))
                
                var counting: Array<Int> = Array(repeating: 0, count: nameset.count)
               
                self.stations = data.stations.filter {
                    let index = nameset.firstIndex(of: $0.stationName) as! Int
                    counting[index] += 1
                    return counting[index] < 2
                }
                
                print("결과:\(self.stations)")
                self.tableView.reloadData()
            }
    }
}

extension StationSearchViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        tableView.reloadData() // after ending edit tableview == [] 를 반영한다.
        tableView.isHidden = false
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        tableView.isHidden = true
        stations = [] // reset
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        requestStationName(from: searchText)
    }
}

extension StationSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // select row
        let station = stations[indexPath.row]
        let detailViewController = StationDetailViewController(station: station)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

extension StationSearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        cell.textLabel?.text = "\(stations[indexPath.row].stationName)"
        cell.detailTextLabel?.text = "\(stations[indexPath.row].lineNumber)"
        return cell
    }
    
    
}

private extension StationSearchViewController {
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

