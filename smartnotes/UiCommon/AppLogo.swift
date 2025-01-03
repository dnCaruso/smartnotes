//
//  AppLogo.swift
//  smartnotes
//
//  Created by admin on 14/12/24.
//

import SwiftUI

struct AppLogo: View {
    let color: Color
    
    var body: some View {
        Text("smartnotes.")
            .font(.headline)
            .fontWeight(.bold)
            .foregroundStyle(color)
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    AppLogo(color: .black)
}
