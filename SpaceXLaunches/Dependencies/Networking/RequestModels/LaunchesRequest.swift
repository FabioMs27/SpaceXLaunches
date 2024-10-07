//
//  LaunchesRequest.swift
//  SpaceXLaunches
//
//  Created by Fábio Maciel de Sousa on 08.10.2024.
//

import Foundation

struct LaunchesRequest: Codable {
    let query: Query
    let options: Options
    
    init(
        query: Query = .init(),
        options: Options
    ) {
        self.query = query
        self.options = options
    }
    
    struct Query: Codable {  }
    
    struct Options: Codable {
        let select: String?
        let sort: String?
        let offset: Int?
        let page: Int
        let limit: Int
        let pagination: Bool
        
        init(
            select: String? = .none,
            sort: String? = .none,
            offset: Int? = .none,
            page: Int,
            limit: Int,
            pagination: Bool = true
        ) {
            self.select = select
            self.sort = sort
            self.offset = offset
            self.page = page
            self.limit = limit
            self.pagination = pagination
        }
    }
}

extension LaunchesRequest {
    init(page: Int, pageSize: Int) {
        self = .init(
            options: .init(
                page: page,
                limit: pageSize
            )
        )
    }
}
