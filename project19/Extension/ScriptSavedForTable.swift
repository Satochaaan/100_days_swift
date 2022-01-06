//
//  ScriptSavedForTable.swift
//  Extension
//
//  Created by 川野智史 on 2022/01/04.
//  Copyright © 2022 Paul Hudson. All rights reserved.
//

import Foundation

class ScriptSavedForTableView: NSObject, Codable {
    var tableName: String?
    var tableScript: String?

    init (tableName: String, tableScript: String) {
        self.tableName = tableName
        self.tableScript = tableScript
    }
}
