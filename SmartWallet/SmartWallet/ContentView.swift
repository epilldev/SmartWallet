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

    // Busca as despesas salvas
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

                ForEach(despesas) { despesa in

                    VStack(alignment: .leading, spacing: 5) {

                        Text(despesa.nome ?? "")
                            .font(.headline)

                        Text("Categoria: \(despesa.categoria ?? "")")

                        Text("Mês: \(despesa.mes ?? "")")

                        Text(
                            "Valor: R$ \(despesa.valor, specifier: "%.2f")"
                        )
                        .fontWeight(.bold)
                    }
                    .padding(.vertical, 5)
                }
                .onDelete(perform: deletarDespesa)
            }
            .navigationTitle("SmartWallet")
            .toolbar {

                ToolbarItem(placement: .navigationBarTrailing) {

                    Button(action: adicionarDespesa) {

                        Label("Adicionar", systemImage: "plus")
                    }
                }
            }
        }
    }

    // Adiciona uma despesa de exemplo
    private func adicionarDespesa() {

        withAnimation {

            let novaDespesa = Despesa(context: viewContext)

            novaDespesa.id = UUID()
            novaDespesa.nome = "Internet"
            novaDespesa.valor = 120.0
            novaDespesa.categoria = "Internet"
            novaDespesa.mes = "Maio"
            novaDespesa.dataCriacao = Date()

            salvarContexto()
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
}

#Preview {

    ContentView()
        .environment(
            \.managedObjectContext,
            PersistenceController.preview.container.viewContext
        )
}
