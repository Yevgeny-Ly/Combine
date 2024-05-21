//
//  ContentView.swift
//  Combine_SwiftUI
//

import SwiftUI
import Combine

struct TaxiView: View {
    
    @StateObject var viewModel = FirstCancellablePipelineViewModel()
    
    var body: some View {
        VStack {
            Spacer()
            Text(viewModel.data)
                .font(.title)
                .foregroundColor(.green)
            Text(viewModel.status)
                .foregroundColor(.blue)
            Spacer()
            orderView
            cancel
        }
    }
    
    private var orderView: some View {
        Button(action: {
            viewModel.refresh()
        }, label: {
            Text("Заказать другой автомобиль")
                .foregroundColor(.white)
                .padding()
                .background(.blue)
                .clipShape(RoundedRectangle(cornerRadius: 20))
        })
    }
    
    private var cancel: some View {
        Button(action: {
            viewModel.cancel()
        }, label: {
            Text("Отмена такси")
                .foregroundColor(.white)
                .padding()
                .background(.cyan)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .opacity(viewModel.status == "Ищем машину..." ? 1.0 : 0.0)
        })
    }
    
}

class FirstCancellablePipelineViewModel: ObservableObject {
    @Published var data = ""
    @Published var status = ""
    
    private var cancellable: AnyCancellable?
    
    init() {
        cancellable = $data
            .map { [unowned self] value -> String in
                status = "Ищем машину..."
                return value
            }
            .delay(for: 7, scheduler: DispatchQueue.main)
            .sink(receiveValue: { [unowned self] value in
                data = "Водитель будет через 10 минут"
                status = "Машина найдена"
            })
    }
    
    func refresh() {
        data = "Уже ищем машину"
    }
    
    func cancel() {
        status = "Машина отменена"
        cancellable?.cancel()
        cancellable = nil
    }
}

#Preview {
    TaxiView()
}