//
//  ExplainFeatureApp.swift
//  ExplainFeature
//
//  Created by ParkJunHyuk on 7/29/25.
//  Copyright © 2025 soongan. All rights reserved.
//

import Foundation

import SwiftUI
import ComposableArchitecture
import ExplainFeature

@main
struct ExplainFeatureApp: App {
    var body: some Scene {
        WindowGroup {
            ExplainView(
                store: Store(
                    initialState: ExplainFeature.State(reportId: "demo-push-id"),
                    reducer: { ExplainFeature() }
                )
            )
        }
    }
}
