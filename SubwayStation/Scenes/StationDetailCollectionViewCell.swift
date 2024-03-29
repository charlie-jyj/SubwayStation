//
//  StationDetailCollectionViewCell.swift
//  SubwayStation
//
//  Created by UAPMobile on 2022/02/09.
//

import UIKit
import SnapKit

class StationDetailCollectionViewCell: UICollectionViewCell {
    private lazy var lineLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 18.0, weight: .semibold)
        return label
    }()
    
    private lazy var remainTimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 16.0, weight: .regular)
        return label
    }()
}

extension StationDetailCollectionViewCell {
    func setupViews(with realTimeArrival: StationArrivalDataResponseModel.RealTimeArrival) {
        lineLabel.text = realTimeArrival.line
        remainTimeLabel.text = realTimeArrival.remainTime
        
        setupLayout()
    }
    
    private func setupLayout() {
        backgroundColor = .systemBackground
        layer.cornerRadius = 10
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 10
        
        [lineLabel, remainTimeLabel].forEach {
            addSubview($0)
        }
        
        lineLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16.0)
            $0.leading.equalToSuperview().inset(16.0)
            $0.trailing.equalToSuperview()
        }
        
        remainTimeLabel.snp.makeConstraints {
            $0.top.equalTo(lineLabel.snp.bottom).offset(4.0)
            $0.leading.trailing.equalTo(lineLabel)
            $0.bottom.equalToSuperview().inset(16.0)
        }
    }
}
