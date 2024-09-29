import SwiftUI

public struct ContentView: View {
    @StateObject var viewModel = ViewModel()

    public init() {}

    public var body: some View {
        NavigationSplitView {
            SidebarView(topic: $viewModel.topic)
        } content: {
            ScrollView {
                VStack {
                    ForEach(viewModel.resources, id: \.hashValue) {
                        Text($0)
                    }
                }
            }
        } detail: {
            VStack {
                ScrollView {
                    Text("Some interesting swift topic")
                    VStack {
                        if let content =  viewModel.displayedContent {
                            Text(content)
                                .frame(width: 480, alignment: .leading)
                                .padding()
                                .background(Color.secondary.opacity(0.1))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .overlay(alignment: .topTrailing) {
                                    Button("Execute code", systemImage: "play") {
                                        Task {
                                            do {
                                                try await viewModel.executeCode()
                                            } catch {
                                                print(error)
                                            }
                                        }
                                    }
                                    .padding(8)
                                }
                            Text(viewModel.quiz.question)
                                .font(.title)
                                .frame(width: 480, alignment: .leading)

                            VStack {
                                ForEach(viewModel.quiz.answers) {
                                    Text($0.title)
                                }
                            }.padding()
                            Button("Submit") {
                                viewModel.submitResult(viewModel.quiz.answers[0])
                            }

                        }
                    }.frame(maxWidth: .infinity)
                }
                ScrollView {
                    VStack {
                        ForEach(viewModel.consoleOutput, id: \.hashValue) {
                            Text($0)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }.padding(.top)
                }
                .frame(height: 160)
                .frame(maxWidth: .infinity)
                .background(.gray.opacity(0.3))
                .overlay(alignment: .topLeading) {
                    Text("Execution results")
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

typealias DisplayedContent = String

final class ViewModel: ObservableObject {
    @Published var topic: Topic = .generalSwift
    @Published var resources: [TopicResource] = []
    @Published var displayedContent: DisplayedContent?
    @Published var quiz: Quiz = .init()
    @Published var consoleOutput: [String] = []

    init() {
        Task { [self] in
            let resources = try await TopicResourceProvider.resources(for: .memoryManagement)
            let content = try TopicResourceProvider.content(topic: .memoryManagement, resource: "Structure+Closure")
            await MainActor.run {
                self.resources = resources
                self.displayedContent = content
            }
        }
    }

    func submitResult(_ answer: Quiz.Answer) {

    }

    @MainActor
    func executeCode() async throws {
        let process = Process()
        let filePath = FileManager.default.temporaryDirectory.appendingPathComponent("\(UUID().uuidString).swift")
        guard let data = displayedContent?.data(using: .utf8) else { return }
        try data.write(to: filePath)
        let result = try process.run(URL(fileURLWithPath: "/usr/bin/swift"), arguments: [filePath.path])
        self.consoleOutput.append(result)
    }
}


struct Quiz {
    let question: String = "Will the object be released?"
    let answers: [Answer] = [
        .init(title: "No", isCorrect: true),
        .init(title: "Yes", isCorrect: false)
    ]

    struct Answer: Hashable, Identifiable {
        let title: String
        let isCorrect: Bool
    }
}


extension Identifiable where Self: Hashable {
    var id: Int {
        hashValue
    }
}


extension String : LocalizedError {
    public var errorDescription: String? { self }
}

extension Process {

    func run(_ executableURL: URL, arguments: [String]? = nil) throws -> String {
        self.executableURL = executableURL
        self.arguments = arguments

        let pipe = Pipe()
        standardOutput = pipe
        standardError = pipe

        try run()
        waitUntilExit()

        guard terminationStatus == EXIT_SUCCESS else {
            let error = String(data: pipe.fileHandleForReading.readDataToEndOfFile(), encoding: .utf8)
            throw (error?.trimmingCharacters(in: .newlines) ?? "")
        }

        let output = String(data: pipe.fileHandleForReading.readDataToEndOfFile(), encoding: .utf8)
        return output?.trimmingCharacters(in: .newlines) ?? ""
    }
}
