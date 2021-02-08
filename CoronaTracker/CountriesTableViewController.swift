//
//  CountriesTableViewController.swift
//  CoronaTracker
//
//  Created by Derrick Park on 2021-01-19.
//

import UIKit

class CountryCell: UITableViewCell {
    @IBOutlet var flagImage: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var casesLabel: UILabel!
}

class CountriesTableViewController: UITableViewController {
    
    var countries = [Country]()
    var filteredCountries = [Country]()
    let searchController = UISearchController(searchResultsController: nil)
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        title = dateFormatter.string(from: Date())
        fetchCoronaData()
        // search controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Countries"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    func fetchCountryFlag(country: Country, indexPath: IndexPath) {
        // fetching flag image from API
        let flagURL = URL(string: "https://www.countryflags.io/\(country.code)/flat/48.png")!
        let downloadPicTask = URLSession.shared.dataTask(with: flagURL) { (data, response, error) in
            if let err = error {
                // filter out error
                print("Error downloading picture: \(err)")
            } else {
                if let imageData = data {
                    DispatchQueue.main.async {
                        if let cell = self.tableView.cellForRow(at: indexPath) as? CountryCell {
                            cell.flagImage.image = UIImage(data: imageData)
                        }
                    }
                } else {
                    print("Image is nil")
                }
            }
        }
        downloadPicTask.resume()
    }
    
    fileprivate func fetchCoronaData() {
        let url = URL(string: "https://corona-api.com/countries")!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print("Invalid request!")
                return
            }
            do {
                if let data = data {
                    let decoder = JSONDecoder()
                    let countries = try decoder.decode(Countries.self, from: data)
                    self.countries = countries.data
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            } catch {
                print("Decoding Error!")
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFiltering {
            return filteredCountries.count
        } else {
            return countries.count
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 65
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell", for: indexPath) as! CountryCell
        var country: Country
        if isFiltering {
            country = filteredCountries[indexPath.row]
        } else {
            country = countries[indexPath.row]
        }
        
        cell.titleLabel?.text = country.name
        cell.casesLabel?.text = "Confirmed:  \(country.today.confirmed)"
        fetchCountryFlag(country: country, indexPath: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredCountries = countries.filter { (country: Country) -> Bool in
            return country.name.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
    }
    
    @IBSegueAction func goToDetail(_ coder: NSCoder) -> DetailTableViewController? {
        let selectedIndexPath = tableView.indexPathForSelectedRow!
        var country: Country
        if isFiltering {
            country = filteredCountries[selectedIndexPath.row]
        } else {
            country = countries[selectedIndexPath.row]
        }
        return DetailTableViewController(country: country, coder: coder)
    }
    
}

extension CountriesTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
    
}
