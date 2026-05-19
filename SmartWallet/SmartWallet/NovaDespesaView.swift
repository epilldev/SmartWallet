//
//  NovaDespesaView.swift
//  SmartWallet
//
//  Created by Oliveira, Felipe Joaquim de on 19/05/26.
//

import SwiftUI
import CoreData

struct NovaDespesaView: View {

    @Environment(\.managedObjectContext)
    private var viewContext

    @Environment(\.dismiss)
    private var dismiss

    @State private var nome = ""
    @State private var valor = ""

    @State private var categoria = "Mercado"
    @State private var mes = "Janeiro"

    let categorias = [
        "Energia",
        "Internet",
        "Água",
        "Assinaturas",
        "Aluguel",
        "Mercado",
        "Cursos",
        "Lazer"
    ]

    let meses = [
        "Janeiro",
        "Fevereiro",
        "Março",
        "Abril",
        "Maio"
    ]

    var body: some View {

        NavigationView {

            Form {

                Section("Informações") {

                    TextField(
                        "Nome da despesa",
                        text: $nome
                    )

                    TextField(
                        "Valor",
                        text: $valor
                    )
                    .keyboardType(.decimalPad)
                }

                Section("Categoria") {

                    Picker("Categoria", selection: $categoria) {

                        ForEach(categorias, id: \.self) {

                            Text($0)
                        }
                    }
                }

                Section("Mês") {

                    Picker("Mês", selection: $mes) {

                        ForEach(meses, id: \.self) {

                            Text($0)
                        }
                    }
                }
            }
            .navigationTitle("Nova Despesa")
            .toolbar {

                ToolbarItem(placement: .navigationBarTrailing) {

                    Button("Salvar") {

                        salvarDespesa()
                    }
                }
            }
        }
    }

    // Salva nova despesa no Core Data
    private func salvarDespesa() {

        let novaDespesa = Despesa(context: viewContext)

        novaDespesa.id = UUID()
        novaDespesa.nome = nome
        novaDespesa.valor = Double(valor) ?? 0.0
        novaDespesa.categoria = categoria
        novaDespesa.mes = mes
        novaDespesa.dataCriacao = Date()

        do {

            try viewContext.save()

            dismiss()

        } catch {

            print("Erro ao salvar despesa")
        }
    }
}

#Preview {

    NovaDespesaView()
        .environment(
            \.managedObjectContext,
            PersistenceController.preview.container.viewContext
        )
}
