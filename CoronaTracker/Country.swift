//
//  Country.swift
//  CoronaTracker
//
//  Created by Derrick Park on 2021-01-19.
//

import Foundation

struct Country: Codable {
  var name: String
    var code: String
  var population: Int?
  var today: Today
  var latest_data: LatestData
}

struct Today: Codable {
  var deaths: Int
  var confirmed: Int
}

struct LatestData: Codable {
  var deaths: Int
  var confirmed: Int
  var recovered: Int
  var critical: Int
  var calculated: Calcuated
}

struct Calcuated: Codable {
  var death_rate: Double?
  var recovery_rate: Double?
  var cases_per_million_population: Int
}

struct Countries: Codable {
  var data: [Country]
}
