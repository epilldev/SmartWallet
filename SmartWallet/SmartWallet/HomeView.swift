//
//  HomeView.swift
//  SmartWallet
//

import SwiftUI

struct HomeView: View {

    @State private var entrarNoApp = false

    var body: some View {

        if entrarNoApp {

            ContentView()

        } else {

            VStack(spacing: 25) {

                Spacer()

                Image(systemName: "wallet.pass.fill")
                    .font(.system(size: 90))
                    .foregroundColor(.blue)

                Text("SmartWallet")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text(
                    "Gerencie suas despesas domésticas de forma simples e organizada."
                )
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
                .padding(.horizontal)

                Spacer()

                Button {

                    entrarNoApp = true

                } label: {

                    Text("Começar")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding(.horizontal)

                VStack(spacing: 5) {

                    Text("Criado por Felipe Joaquim")
                        .font(.footnote)
                        .foregroundColor(.gray)

                    Text("© 2026 SmartWallet")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                .padding(.bottom, 10)
            }
            .padding()
        }
    }
}

#Preview {

    HomeView()
}
