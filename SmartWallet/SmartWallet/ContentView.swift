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
                        .foregroundColor(.blue)

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
                            "R$ \(despesa.valor, specifier: "%.2f")"
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
}

#Preview {

    ContentView()
        .environment(
            \.managedObjectContext,
            PersistenceController.preview.container.viewContext
        )
}
