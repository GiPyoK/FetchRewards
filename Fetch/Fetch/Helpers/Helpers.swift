//
//  Helpers.swift
//  Fetch
//
//  Created by Gi Pyo Kim on 8/2/21.
//

import Foundation
import UIKit

class Helper {
    
    static func formatDate (date: String) -> String? {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        if let formattedDate = dateFormatterGet.date(from: date) {
            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "EEEE h:mm a, MMM d yyyy"
            return dateFormatterPrint.string(from: formattedDate)
        } else {
            return nil
        }
    }
    
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
