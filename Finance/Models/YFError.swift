//
//  JSONNull.swift
//  Finance
//
//  Created by Andrii Zuiok on 08.06.2020.
//  Copyright © 2020 Andrii Zuiok. All rights reserved.
//

import Foundation


// MARK: - YFError
public struct YFError: Error, Codable {
    public var code: String?
    public var errorDescription: String?

    enum CodingKeys: String, CodingKey {
        case code = "code"
        case errorDescription = "description"
    }

    public init(code: String?, errorDescription: String?) {
        self.code = code
        self.errorDescription = errorDescription
    }
}
