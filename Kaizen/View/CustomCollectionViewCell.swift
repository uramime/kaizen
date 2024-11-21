//
//  CustomCollectionViewCell.swift
//  Kaizen
//
//  Created by Filip Igrutinovic on 20.11.24..
//

import Foundation
import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    // UI elements
    let time: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = UIColor(named: "WhiteText")
        
        label.sizeToFit()
        label.frame = CGRect(x: label.frame.origin.x, y: label.frame.origin.y, width: 80, height: 25)
        
        // Customize the border
        label.layer.borderColor = UIColor.white.cgColor
        label.layer.borderWidth = 1.0
        label.layer.cornerRadius = 4.0
        label.layer.masksToBounds = true
        
        label.backgroundColor = .clear
        
        return label
    }()
    
    let favourite: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    var team1: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = UIColor(named: "WhiteText")
        label.numberOfLines = 1
        return label
    }()
    
    let team2: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = UIColor(named: "WhiteText")
        label.numberOfLines = 1
        return label
    }()
    
    var eventTime: Int?
    var favouriteTapped: (() -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        
        contentView.addSubview(time)
        contentView.addSubview(favourite)
        contentView.addSubview(team1)
        contentView.addSubview(team2)
        
        // Layout constraints
        NSLayoutConstraint.activate([
            time.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            time.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            time.widthAnchor.constraint(equalToConstant: 80),
            time.heightAnchor.constraint(equalToConstant: 25),
            
            favourite.topAnchor.constraint(equalTo: time.bottomAnchor, constant: 10),
            favourite.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            favourite.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            team1.topAnchor.constraint(equalTo: favourite.bottomAnchor, constant: 10),
            team1.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            team1.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            team2.topAnchor.constraint(equalTo: team1.bottomAnchor, constant: 5),
            team2.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            team2.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapCell))
        self.contentView.addGestureRecognizer(tapGestureRecognizer)
        
        self.contentView.isUserInteractionEnabled = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func updateLabel() {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .medium
        let currentTime = Int(Date().timeIntervalSince1970)
        
        if let eventTime = eventTime {
            let remainTime = eventTime - currentTime
            time.text = convertUnixTimestampToTimeString(TimeInterval(remainTime))
        }
    }
    
    @objc private func didTapCell() {
        favouriteTapped?()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        NotificationCenter.default.removeObserver(self, name: .timeUpdated, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // Method to configure the cell with data
    func configureCell(event: SectionEvent) {
        NotificationCenter.default.addObserver(self, selector: #selector(updateLabel), name: .timeUpdated, object: nil)
        
        self.favourite.text = event.isFavourite ? "✅" : "☑️"
        self.time.text = "-"
        eventTime = event.time
        
        let teams = prepareEventName(name: event.name)
        self.team1.text = teams.0
        self.team2.text = teams.1
    }
    
    private func convertUnixTimestampToTimeString(_ unixTimestamp: TimeInterval) -> String {
        // Create a Date object from the Unix timestamp
        let date = Date(timeIntervalSince1970: unixTimestamp)
        
        // Create a DateFormatter to format the date into "HH:mm:ss"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss" // Specify the desired time format
        dateFormatter.timeZone = TimeZone.current // Use the current time zone
        
        // Convert the Date object to a string
        return dateFormatter.string(from: date)
    }
    
    private func prepareEventName(name: String) -> (String, String) {
        let components = name.split(separator: "-")
        return (String(components[0]), String(components[1]))
    }
}
