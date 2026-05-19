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
        "Maio",
        "Junho",
        "Julho",
        "Agosto",
        "Setembro",
        "Outubro",
        "Novembro",
        "Dezembro"
    ]

    var body: some View {

        NavigationView {

            Form {

                // Cabeçalho visual
                Section {

                    VStack(spacing: 10) {

                        Image(systemName: "creditcard.fill")
                            .font(.system(size: 45))
                            .foregroundColor(.blue)

                        Text("Nova Despesa")
                            .font(.title2)
                            .fontWeight(.bold)

                        Text(
                            "Adicione uma nova despesa doméstica ao SmartWallet."
                        )
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)

                }

                // Informações principais
                Section("Informações") {

                    HStack {

                        Image(systemName: "textformat")
                            .foregroundColor(.blue)

                        TextField(
                            "Nome da despesa *",
                            text: $nome
                        )
                    }

                    HStack {

                        Image(systemName: "dollarsign.circle.fill")
                            .foregroundColor(.green)

                        TextField(
                            "Valor *",
                            text: $valor
                        )
                        .keyboardType(.decimalPad)
                    }

                    Text("* Campos obrigatórios")
                        .font(.caption)
                        .foregroundColor(.gray)
                }

                // Categoria
                Section("Categoria") {

                    HStack {

                        Image(systemName: "tag.fill")
                            .foregroundColor(.orange)

                        Picker(
                            "Categoria",
                            selection: $categoria
                        ) {

                            ForEach(categorias, id: \.self) {

                                Text($0)
                            }
                        }
                    }
                }

                // Mês
                Section("Mês") {

                    HStack {

                        Image(systemName: "calendar")
                            .foregroundColor(.purple)

                        Picker("Mês", selection: $mes) {

                            ForEach(meses, id: \.self) {

                                Text($0)
                            }
                        }
                    }
                }

                // Botão salvar
                Section {

                    Button {

                        salvarDespesa()

                    } label: {

                        HStack {

                            Spacer()

                            Image(systemName: "checkmark.circle.fill")

                            Text("Salvar Despesa")
                                .fontWeight(.bold)

                            Spacer()
                        }
                        .padding()
                        .background(
                            LinearGradient(
                                colors: [.blue, .cyan],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .foregroundColor(.white)
                        .cornerRadius(15)
                    }
                    // Impede salvar campos vazios
                    .disabled(
                        nome.trimmingCharacters(in: .whitespaces).isEmpty ||
                        valor.trimmingCharacters(in: .whitespaces).isEmpty
                    )
                }
                .listRowBackground(Color.clear)
            }
            .navigationTitle("Cadastro")
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
