//
//  StringExtension.swift
//  SpasiboRx
//
//  Created by Pavel Grechikhin on 15/10/2018.
//  Copyright © 2018 Pavel Grechikhin. All rights reserved.
//

import Foundation


extension String {
    func sliceToken(from: String, to: String) -> String? {
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }
}
