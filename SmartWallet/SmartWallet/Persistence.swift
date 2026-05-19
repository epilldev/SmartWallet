//
//  Persistence.swift
//  SmartWallet
//
//  Created by Oliveira, Felipe Joaquim de on 19/05/26.
//

import CoreData

struct PersistenceController {
    
    // Instância principal do Core Data
    static let shared = PersistenceController()

    // Dados fictícios usados apenas nos previews do SwiftUI
    @MainActor
    static let preview: PersistenceController = {
        
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext

        for _ in 0..<10 {
            
            let novaDespesa = Despesa(context: viewContext)
            
            novaDespesa.id = UUID()
            novaDespesa.nome = "Mercado"
            novaDespesa.valor = 150.0
            novaDespesa.categoria = "Mercado"
            novaDespesa.mes = "Janeiro"
            novaDespesa.dataCriacao = Date()
        }

        do {
            try viewContext.save()
        } catch {
            
            let nsError = error as NSError
            
            fatalError("Erro ao salvar preview: \(nsError)")
        }

        return result
    }()

    // Container principal do Core Data
    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        
        // Inicializa o banco com o nome do projeto/model
        container = NSPersistentContainer(name: "SmartWallet")

        // Usado para previews/testes sem salvar em disco
        if inMemory {
            container.persistentStoreDescriptions.first?.url =
                URL(fileURLWithPath: "/dev/null")
        }

        // Carrega o banco de dados
        container.loadPersistentStores { _, error in
            
            if let error = error as NSError? {
                
                fatalError("Erro ao carregar Core Data: \(error)")
            }
        }

        // Mantém sincronização automática do contexto
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
