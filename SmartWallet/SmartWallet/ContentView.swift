//
//  ContentView.swift
//  SmartWallet
//
//  Created by Oliveira, Felipe Joaquim de on 19/05/26.
//

import SwiftUI
import CoreData

struct ContentView: View {

    @Environment(\.managedObjectContext)
    private var viewContext

    // Controla abertura da tela de cadastro
    @State private var mostrarNovaDespesa = false

    // Busca despesas salvas no Core Data
    @FetchRequest(
        sortDescriptors: [
            NSSortDescriptor(
                keyPath: \Despesa.dataCriacao,
                ascending: false
            )
        ],
        animation: .default
    )
    private var despesas: FetchedResults<Despesa>

    var body: some View {

        NavigationView {

            List {

                // Card do total geral
                Section {

                    VStack(spacing: 10) {

                        Text("Total Geral")
                            .font(.headline)
                            .foregroundColor(.white)

                        Text(
                            despesas
                                .reduce(0) { $0 + $1.valor }
                                .formatted(.currency(code: "BRL"))
                        )
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        LinearGradient(
                            colors: [.blue, .cyan],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .cornerRadius(20)
                    .shadow(radius: 5)

                }
                .listRowBackground(Color.clear)

                // Resumo financeiro
                Section {

                    VStack(alignment: .leading, spacing: 10) {

                        Text("Resumo Financeiro")
                            .font(.headline)

                        resumoLinha(mes: "Janeiro")
                        resumoLinha(mes: "Fevereiro")
                        resumoLinha(mes: "Março")
                        resumoLinha(mes: "Abril")
                        resumoLinha(mes: "Maio")
                        resumoLinha(mes: "Junho")
                        resumoLinha(mes: "Julho")
                        resumoLinha(mes: "Agosto")
                        resumoLinha(mes: "Setembro")
                        resumoLinha(mes: "Outubro")
                        resumoLinha(mes: "Novembro")
                        resumoLinha(mes: "Dezembro")
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(15)

                } header: {

                    Text("Totais por mês")
                }

                // Estado vazio
                if despesas.isEmpty {

                    VStack(spacing: 15) {

                        Image(systemName: "tray")
                            .font(.system(size: 50))
                            .foregroundColor(.gray)

                        Text("Nenhuma despesa cadastrada")
                            .font(.headline)

                        Text("Adicione uma nova despesa no botão +")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, minHeight: 300)
                }

                ForEach(despesas) { despesa in

                    HStack(spacing: 15) {

                        Image(
                            systemName: iconeCategoria(
                                despesa.categoria ?? ""
                            )
                        )
                        .font(.title2)
                        .foregroundColor(
                            corCategoria(
                                despesa.categoria ?? ""
                            )
                        )

                        VStack(alignment: .leading, spacing: 5) {

                            Text(despesa.nome ?? "")
                                .font(.headline)

                            Text(despesa.categoria ?? "")
                                .font(.subheadline)
                                .foregroundColor(.gray)

                            Text(despesa.mes ?? "")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }

                        Spacer()

                        Text(
                            despesa.valor.formatted(
                                .currency(code: "BRL")
                            )
                        )
                        .fontWeight(.bold)
                    }
                    .padding(.vertical, 8)
                }
                .onDelete(perform: deletarDespesa)
            }
            .navigationTitle("SmartWallet")
            .toolbar {

                ToolbarItem(placement: .navigationBarTrailing) {

                    Button {

                        mostrarNovaDespesa = true

                    } label: {

                        Label("Adicionar", systemImage: "plus")
                    }
                }
            }
            // Abre tela de cadastro
            .sheet(isPresented: $mostrarNovaDespesa) {

                NovaDespesaView()
                    .environment(
                        \.managedObjectContext,
                        viewContext
                    )
            }
        }
    }

    // Remove despesas da lista
    private func deletarDespesa(offsets: IndexSet) {

        withAnimation {

            offsets.map { despesas[$0] }
                .forEach(viewContext.delete)

            salvarContexto()
        }
    }

    // Salva alterações no Core Data
    private func salvarContexto() {

        do {

            try viewContext.save()

        } catch {

            let nsError = error as NSError

            fatalError("Erro ao salvar: \(nsError)")
        }
    }

    // Retorna ícone conforme categoria
    private func iconeCategoria(_ categoria: String) -> String {

        switch categoria {

        case "Energia":
            return "bolt.fill"

        case "Internet":
            return "wifi"

        case "Água":
            return "drop.fill"

        case "Assinaturas":
            return "tv.fill"

        case "Aluguel":
            return "house.fill"

        case "Mercado":
            return "cart.fill"

        case "Cursos":
            return "book.fill"

        case "Lazer":
            return "gamecontroller.fill"

        default:
            return "dollarsign.circle.fill"
        }
    }

    // Retorna cor conforme categoria
    private func corCategoria(_ categoria: String) -> Color {

        switch categoria {

        case "Energia":
            return .yellow

        case "Internet":
            return .blue

        case "Água":
            return .cyan

        case "Assinaturas":
            return .purple

        case "Aluguel":
            return .orange

        case "Mercado":
            return .green

        case "Cursos":
            return .indigo

        case "Lazer":
            return .pink

        default:
            return .gray
        }
    }

    // Exibe total de despesas por mês
    @ViewBuilder
    private func resumoLinha(mes: String) -> some View {

        let total = despesas
            .filter { $0.mes == mes }
            .reduce(0) { $0 + $1.valor }

        HStack {

            Text(mes)

            Spacer()

            Text(
                total.formatted(
                    .currency(code: "BRL")
                )
            )
            .fontWeight(.bold)
        }
    }
}

#Preview {

    ContentView()
        .environment(
            \.managedObjectContext,
            PersistenceController.preview.container.viewContext
        )
}
