//
//  RouteInProgressCardView.swift
//  Pathy
//
//  Created by Luis Fajardo on 9/16/24.
//

import SwiftUI

struct RouteInProgressCardView: View {
    @ObservedObject var vm: RouteInProgressViewModel
    let startStopSaveAction: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            if vm.routeState != RouteState.notStarted {
                metadata
            }
            startStopButton
        }
        .padding(vm.routeState != RouteState.notStarted ? 16 : 0)
        .background(.thickMaterial, in: .rect(cornerRadius: 32))
    }
    
    @ViewBuilder
    private var metadata: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    Text(vm.formattedDistance)
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .foregroundStyle(.primary)
                        .fontDesign(.rounded)
                        .monospacedDigit()
                    Text("mi")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundStyle(.primary)
                        .fontDesign(.rounded)
                }
                Text("Distance")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .fontDesign(.default)
            }
            Spacer()
            VStack(alignment: .trailing) {
                timeElapsed
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
                    .fontDesign(.rounded)
                    .monospacedDigit()
                Text("Duration")
                    .font(.body)
                    .foregroundStyle(.secondary)
            }
        }
    }
    
    @ViewBuilder
    private var timeElapsed: some View {
        Group {
            switch vm.routeState {
            case .notStarted:
                EmptyView()
            case .inProgress(let startTime):
                Text(startTime, style: .timer)
            case .ended(let startTime, let endTime):
                Text(vm.formatDuration(startTime: startTime, endTime: endTime))
            }
        }
        .monospacedDigit()
        .transition(.scale(0, anchor: .trailing).combined(with: .opacity))
    }
    
    @ViewBuilder
    private var startStopButton: some View {
        Button {
            startStopSaveAction()
        } label: {
            let buttonBackground: Color = switch vm.routeState {
            case .notStarted: .green
            case .inProgress: .red
            case .ended: .blue
            }
            
            let buttonLabel: String = switch vm.routeState {
            case .notStarted: "Start"
            case .inProgress: "Stop"
            case .ended: "Save"
            }
            
            Text(buttonLabel)
                .font(.title3)
                .fontWeight(/*@START_MENU_TOKEN@*/ .bold/*@END_MENU_TOKEN@*/)
                .foregroundStyle(.white)
                .fontDesign(.default)
                .frame(maxWidth: .infinity)
                .padding()
                .background(buttonBackground, in: .rect(cornerRadius: 16))
        }
    }
}

#Preview {
    Group {
        RouteInProgressCardView(vm: RouteInProgressViewModel(), startStopSaveAction: {})
    }
}
