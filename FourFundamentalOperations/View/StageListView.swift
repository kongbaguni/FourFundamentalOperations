//
//  StageListView.swift
//  FourFundamentalOperations
//
//  Created by Changyeol Seo on 4/2/24.
//

import SwiftUI
import RealmSwift


struct StageListView: View {
    @Environment(\.isPreview) var isPreview
    
    @State var error:Error? = nil {
        didSet {
            if error != nil {
                isAlert = true
            }
        }
    }
    @State var isAlert:Bool = false
    @ObservedResults(StageModel.self,
                     sortDescriptor: .init(keyPath: "regDateTimeInterval1970", ascending: true)
    ) var list
    
    var body: some View {
        Group {
            if isPreview {
                ForEach([StageModel.Stage1,StageModel.Stage1,StageModel.Stage1], id: \.self) { item in
                    NavigationLink {
                        GameView(model:nil, stage: item)
                    } label: {
                        item.title
                    }
                }
            } else {
                ForEach(list, id: \.self) { item in
                    NavigationLink {
                        GameView(model:nil, stage: item)
                    } label: {
                        item.title
                    }
                }
            }
        }
        .onAppear {
            load()            
        }
        .alert(isPresented: $isAlert, content: {
            .init(title: .init("alert"), message: .init(error!.localizedDescription))
        })
    }
    
    func load() {
        if !isPreview {
            StageModel.sync { error in
                self.error = error
            }
        }
    }
}

#Preview {
    StageListView()
}
