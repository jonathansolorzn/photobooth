//
//  String+DataEncoded.swift
//  Photobooth
//
//  Created by Jonathan Solorzano on 20/4/22.
//

import Foundation

extension String {
    var dataEncoded: Data {
        return self.data(using: String.Encoding.utf8)!
    }
}
