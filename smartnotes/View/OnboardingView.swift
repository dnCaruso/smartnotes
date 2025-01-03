//
//  Onboarding.swift
//  smartnotes
//
//  Created by admin on 06/12/24.
//

import SwiftUI

struct Onboarding: View {
    @Environment(\.modelContext) private var context
    var body: some View {
        NavigationView {
            ZStack {
                Color("PrimaryColor")
                    .ignoresSafeArea()
                
                VStack {
                    AppLogo(color: .black)
                    
                    Spacer()
                    
                    OnboardingTitle()
                    
                    Spacer()
                    
                    NavigationLink(destination: HomeView(context: context)) {
                        RoundedButton()
                    }
                }
                .padding(.leading, 16)
                
                OnboardingLinesDesign()
            }
        }
    }
}

#Preview {
    Onboarding()
        .modelContainer(SampleData.shared.modelContainer)
}

struct OnboardingTitle: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("create")
                .font(.system(size: 48, weight: .bold))
            Text("notes")
                .font(.system(size: 48, weight: .bold))
            Text("smarter.")
                .font(.system(size: 48, weight: .bold))
        }
        .frame(maxWidth: .infinity, maxHeight: 350, alignment: .topLeading)
        .padding(.bottom, 32)
    }
}

struct RoundedButton: View {
    var body: some View {
        Image(systemName: "chevron.right")
            .foregroundStyle(.black)
            .frame(width: 60, height: 60)
            .background(Circle().fill(Color("SecondaryColor")))
            .padding(.bottom)
    }
}

struct OnboardingLinesDesign: View {
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let width = geometry.size.width
                let height = geometry.size.height
                
                path.move(to: CGPoint(x: width, y: 40))
                path.addLine(to: CGPoint(x: width - 40, y: 40))
                path.addLine(to: CGPoint(x: width - 40, y: 100))
                path.addLine(to: CGPoint(x: width - 100, y: 100))
                path.addLine(to: CGPoint(x: width - 95, y: height - 300))
                path.addLine(to: CGPoint(x: width - 160, y: height - 300))
                path.addLine(to: CGPoint(x: width - 160, y: height - 220))
                path.addLine(to: CGPoint(x: width - 320, y: height - 220))
                path.addLine(to: CGPoint(x: width - 320, y: height - 250))
            }
            .stroke(Color.black, lineWidth: 1)
            
            Image(systemName: "lightbulb.max")
                .resizable()
                .frame(width: 50, height: 60)
                .foregroundColor(.black)
                .position(x: geometry.size.width - 320, y: geometry.size.height - 280)
        }
    }
}
