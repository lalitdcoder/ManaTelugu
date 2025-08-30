//
//  ContentView.swift
//  ManaTelugu
//
//  Created by Dusanapudi on 28/08/2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var session = AppSession()
    
    var body: some View {
        RootTabView()
            .environmentObject(session)
    }
}

#Preview {
    ContentView()
}