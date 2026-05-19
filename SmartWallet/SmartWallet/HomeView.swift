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

            ZStack {

                // Fundo com gradiente
                LinearGradient(
                    colors: [
                        Color.blue.opacity(0.15),
                        Color.cyan.opacity(0.10),
                        Color.white
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack(spacing: 30) {

                    Spacer()

                    // Ícone principal
                    ZStack {

                        Circle()
                            .fill(Color.white)
                            .frame(width: 170, height: 170)
                            .shadow(color: .blue.opacity(0.2), radius: 15)

                        Image(systemName: "wallet.pass.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.blue)
                    }

                    VStack(spacing: 10) {

                        Text("SmartWallet")
                            .font(.system(size: 38, weight: .bold))

                        Text(
                            "Controle financeiro simples para o seu dia a dia."
                        )
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.gray)
                        .padding(.horizontal)

                        Text(
                            "Gerencie despesas domésticas com praticidade e organização."
                        )
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                    }

                    Spacer()

                    // Botão principal
                    Button {

                        entrarNoApp = true

                    } label: {

                        HStack {

                            Text("Começar")
                                .fontWeight(.bold)

                            Image(systemName: "arrow.right")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(
                                colors: [.blue, .cyan],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .foregroundColor(.white)
                        .cornerRadius(16)
                        .shadow(
                            color: .blue.opacity(0.3),
                            radius: 8,
                            y: 4
                        )
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
}

#Preview {

    HomeView()
}
