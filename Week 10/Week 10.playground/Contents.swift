import Cocoa

struct Fact: Codable {
  var fact: String
  var length: Int
}

struct FactSequence: AsyncSequence {
  typealias Element = Fact

  let count: Int

  init(count: Int) {
    self.count = count
  }

  func makeAsyncIterator() -> FactIterator {
    return FactIterator(count)
  }
}

struct FactIterator: AsyncIteratorProtocol {
  typealias Element = Fact

  private var index = 0
  private var count: Int

  init(_ count: Int) {
    self.count = count
  }

  mutating func next() async throws -> Fact? {
    guard index <= count else {
      return nil
    }

    do {
      let url = URL(string: "https://catfact.ninja/fact")!
      let (data, _) = try await URLSession.shared.data(from: url)
      let fact = try JSONDecoder().decode(Fact.self, from: data)
      index += 1
      return fact
    } catch {
      return nil
    }
  }
}

func getCatFacts(count: Int) async -> [Fact] {
  var facts: [Fact] = []
  do {
    for try await fact in FactSequence(count: count) {
      facts.append(fact)
    }
  } catch {
    print(error)
  }
  return facts
}

Task {
  let catFacts = await getCatFacts(count: 5)
  for fact in catFacts {
    print(fact.fact)
  }
}
