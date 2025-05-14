//
//  SoonganApp.swift
//  Soongan
//
//  Created by ParkJunHyuk on 5/7/25.
//  Copyright © 2025 Captures. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

import AuthFeature

@main
struct SoonganApp: App {
    var body: some Scene {
        WindowGroup {
            AppView(
                store: Store(
                    initialState: AppFeature.State(),
                    reducer:  {
                        AppFeature()
                    }
                )
            )
        }
    }
}
