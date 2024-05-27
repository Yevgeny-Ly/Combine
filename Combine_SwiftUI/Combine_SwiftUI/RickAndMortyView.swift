//
//  ContentView.swift
//  Combine_SwiftUI
//

import SwiftUI
import Combine

struct RickAndMortyView: View {
    
    var body: some View {
        VStack {
            switch viewModel.state {
            case .loading:
                loadingLogoView
            case .loaded:
                headerNameView
                searchTextFieldView
                ZStack {
                    panelFilterView
                    filterView
                }
                listView
                    .padding(.horizontal, 20)
            case .error(let error):
                EmptyView()
                    .alert(isPresented: $viewModel.isShowAlert) {
                        Alert(title: Text("Ошибка"),
                              message: Text(error.localizedDescription),
                              dismissButton: .default(Text("OK")) {
                        })
                    }
            }
        }
        .onAppear {
            viewModel.fetch()
            viewModel.fetchImage()
        }
    }
    
    @StateObject var viewModel = RickAndMortyViewModel()
    @State private var text = ""
    
    private var loadingLogoView: some View {
        Image(.logo)
            .rotationEffect(.degrees(self.viewModel.isConnecting ? 360 : 0))
            .onAppear {
                viewModel.performAnimation()
            }
    }
    
    private var headerNameView: some View {
        Image(.rickMorty)
    }
    
    private var searchTextFieldView: some View {
        TextField("Name or episode (ex.S01E01)...", text: $text)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .frame(width: 312, height: 56)
    }
    
    private var panelFilterView: some View {
        RoundedRectangle(cornerRadius: 10.0)
            .frame(width: 312, height: 56)
            .foregroundColor(.backgroundPanelFilter)
            .shadow(color: .gray.opacity(0.5), radius: 4, y: 2)
    }
    
    private var filterView: some View {
        HStack {
            Image(.filterIcon)
                .padding(.leading, -50)
            Text("ADVANCED FILTERS")
                .foregroundColor(.blue)
                .font(.body)
        }
    }
    
    private var listView: some View {
        List(viewModel.dataToEpisode, id: \.id) { series in
            RoundedRectangle(cornerRadius: 10)
                .fill(.white)
                .shadow(color: .gray.opacity(0.5), radius: 4, y: 2)
                .frame(width: 311, height: 415)
                .overlay(
                    VStack {
                        if let character = viewModel.dataToCharacters.first {
                            AsyncImage(url: URL(string: character.image)) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            } placeholder: {
                                ProgressView()
                            }
                            HStack {
                                Text("\(character.name)")
                                    .font(.title3)
                                    .bold()
                                Spacer()
                            }
                            .padding(.leading, 15)
                        }
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.backgroundPanelFilter.opacity(0.4))
                            .frame(width: 311, height: 71)
                            .overlay(
                                HStack {
                                    Image(.monitorPlayLogo)
                                    Text(series.name)
                                    Text("|")
                                    Text(series.episode)
                                    Spacer()
                                    Image(.heart)
                                }
                                    .padding()
                            )
                    }
                )
        }
        .listStyle(PlainListStyle())
        .scrollIndicators(.never)
    }
}

final class RickAndMortyViewModel: ObservableObject {
    @Published var dataToEpisode: [Episode] = []
    @Published var dataToCharacters: [Characters] = []
    @Published var state: ViewState<String> = .loading
    @Published var isConnecting: Bool = false
    @Published var isShowAlert: Bool = false
    
    let varificationState = PassthroughSubject<String, Never>()
    var cancellable: AnyCancellable?
    var cancellables: Set<AnyCancellable> = []
    
    init() {
        bind()
    }
    
    func fetch() {
        guard let url = URL(string: "https://rickandmortyapi.com/api/episode") else { return }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: RickMortyEpisode.self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    print(error.localizedDescription)
                }
            } receiveValue: { [unowned self] posts in
                dataToEpisode = posts.results
            }
            .store(in: &cancellables)
    }
    
    func fetchImage() {
        guard let url = URL(string: "https://rickandmortyapi.com/api/character") else { return }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: RickMortyCharacters.self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    print(error.localizedDescription)
                }
            } receiveValue: { [unowned self] images in
                dataToCharacters = images.results
            }
            .store(in: &cancellables)
    }
    
    func bind() {
        cancellable = varificationState
            .sink(receiveValue: { [unowned self] value in
                if !value.isEmpty {
                    state = .loaded(value)
                } else {
                    state = .error(NSError(domain: "Error", code: 101))
                    isShowAlert = true
                }
            })
    }
    
    func performAnimation() {
        let cancellable = Just(())
            .delay(for: .seconds(0), scheduler: DispatchQueue.main)
            .map { _ in true }
            .handleEvents(receiveOutput: { [weak self] _ in
                withAnimation(Animation.linear(duration: 0.9).repeatForever(autoreverses: false)) {
                    self?.isConnecting = true
                }
            })
        
            .delay(for: .seconds(2), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.state = .loaded(String())
                self?.isConnecting = false
            }
        cancellable.store(in: &cancellables)
    }
}

struct RickMortyEpisode: Decodable {
    let results: [Episode]
}

struct Episode: Decodable {
    let id: Int
    let name: String
    let airDate: String
    let episode: String
    let characters: [String]
    let url: String
    let created: String
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case airDate = "air_date"
        case episode, characters, url, created
    }
}

struct RickMortyCharacters: Decodable {
    let results: [Characters]
}

struct Characters: Decodable {
    let id: Int
    let name: String
    let image: String
    let episode: [String]
}

enum ViewState<Model> {
    case loading
    case loaded(_ data: Model)
    case error(_ error: Error)
}

#Preview {
    RickAndMortyView()
}

