//
//  Brewery.swift
//  rx medium article
//
//  Created by Pramodya Abeysinghe on 10/11/20.
//

import Foundation

struct Brewery: Codable {
    var id: Int?
    var name, breweryType, street, city: String?
    var state, postalCode, country, longitude: String?
    var latitude, phone: String?
    var websiteURL: String?
    var updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case breweryType = "brewery_type"
        case street, city, state
        case postalCode = "postal_code"
        case country, longitude, latitude, phone
        case websiteURL = "website_url"
        case updatedAt = "updated_at"
    }
}
