//
//  DetailTableViewController.swift
//  CoronaTracker
//
//  Created by Derrick Park on 2021-01-19.
//

import UIKit

class DetailTableViewController: UITableViewController {
    
    private let country: Country
    @IBOutlet var flagImage: UIImageView!
    @IBOutlet var countryLabel: UILabel!
    @IBOutlet var populationLabel: UILabel!
    @IBOutlet var todayDeathsLabel: UILabel!
    @IBOutlet var todayConfirmedLabel: UILabel!
    @IBOutlet var totalDeathsLabel: UILabel!
    @IBOutlet var totalConfirmedLabel: UILabel!
    @IBOutlet var totalRecoveredLabel: UILabel!
    @IBOutlet var totalCriticalLabel: UILabel!
    @IBOutlet var deathRateLabel: UILabel!
    @IBOutlet var recoveryRateLabel: UILabel!
    @IBOutlet var casesPerMillionLabel: UILabel!
    
    init!(country: Country, coder: NSCoder) {
        self.country = country
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let flagURL = URL(string: "https://www.countryflags.io/\(country.code)/flat/48.png")!
        let downloadPicTask = URLSession.shared.dataTask(with: flagURL) { (data, response, error) in
            if let err = error {
                // filter out error
                print("Error downloading picture: \(err)")
            } else {
                if let imageData = data {
                    DispatchQueue.main.async {
                        self.flagImage.image = UIImage(data: imageData)
                    }
                } else {
                    print("Image is nil")
                }
            }
        }
        downloadPicTask.resume()
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        countryLabel.text = country.name
        populationLabel.text = "Population: \(formatter.string(from: NSNumber(value: country.population ?? 0))!)"
        todayDeathsLabel.text = "Deaths: \(country.today.deaths)"
        todayConfirmedLabel.text = "Confirmed: \(formatter.string(from: NSNumber(value: country.today.confirmed))!)"
        totalDeathsLabel.text = "Total Deaths: \(formatter.string(from: NSNumber(value: country.latest_data.deaths))!)"
        totalConfirmedLabel.text = "Total Confirmed: \(formatter.string(from: NSNumber(value: country.latest_data.confirmed))!)"
        totalRecoveredLabel.text = "Total Recovered: \(formatter.string(from: NSNumber(value: country.latest_data.recovered))!)"
        totalCriticalLabel.text = "Total Critical: \(formatter.string(from: NSNumber(value: country.latest_data.critical))!)"
        deathRateLabel.text = "\(String(format: "Death Rate: %.2f", country.latest_data.calculated.death_rate ?? 0))%"
        recoveryRateLabel.text = "\(String(format: "Recovery Rate: %.2f%", country.latest_data.calculated.recovery_rate ?? 0))%"
        casesPerMillionLabel.text = "Cases Per Million: \(country.latest_data.calculated.cases_per_million_population)"
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
