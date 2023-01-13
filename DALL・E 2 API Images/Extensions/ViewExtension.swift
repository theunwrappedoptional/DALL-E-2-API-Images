//
//  ViewExtension.swift
//  DALL・E 2 API Images
//
//  Created by Manhattan on 12/01/23.
//

import SwiftUI

extension View {
    func hideKeyboard() {
        let resign = #selector(UIResponder.resignFirstResponder)
        UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
    }
}
