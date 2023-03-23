//
//  Endpoint.swift
//  PokeApp
//
//  Created by Oktay Tanrıkulu on 23.03.2023.
//

import Foundation
import Alamofire

enum Endpoint {
    case list(limit: Int, offset: Int), detail(id: Int), ability(id: Int)
}

extension Endpoint: TargetType {
    var baseURL: String {
        return AppConstants.BaseURL
    }
    
    var path: String {
        switch self {
        case .list:
            return "/pokemon/?"
        case .detail(let id):
            return "/pokemon/\(id)"
        case .ability(let id):
            return "/ability/\(id)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .list, .detail, .ability: return .get
        }
    }
    
    var task: Task {
        switch self {
        case .list(let limit, let offset):
            return .requestParameters(parameters: ["limit" : limit, "offset" : offset], encoding: URLEncoding.default)
        case .detail, .ability:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        default:
            return [:]
        }
    }
    
}
