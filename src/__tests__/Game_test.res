open Jest
open Expect

let initial: Models.state = {
  grid: [
    [Inactive, Inactive, Inactive, Inactive, Inactive],
    [Inactive, Inactive, Inactive, Inactive, Inactive],
    [Inactive, Inactive, Inactive, Inactive, Inactive],
    [Inactive, Inactive, Inactive, Inactive, Inactive],
    [Inactive, Inactive, Inactive, Inactive, Inactive],
  ],
  currentNode: (0, 0),
  solution: "hello",
  gameState: Playing,
  invalidGuess: None,
  incorrectGuesses: [],
}

let generateInitial = node => {
  ...initial,
  currentNode: node,
}

describe("nextNode", () => {
  test("finds the next guess in a line", () => {
    expect(initial->Utils.nextNode)->toEqual((0, 1))
  })
  test("finds next line", () => {
    let next = (0, 4)->generateInitial
    expect(next->Utils.nextNode)->toEqual((1, 0))
  })
  test("ends at last node", () => {
    let next = (4, 4)->generateInitial
    expect(next->Utils.nextNode)->toEqual((4, 4))
  })
})

describe("insertValueIntoGrid", () => {
  test("inserts first value", () => {
    expect(initial->Utils.insertValueIntoGrid(Some("v")))->toEqual([
      [Guessed("v"), Inactive, Inactive, Inactive, Inactive],
      [Inactive, Inactive, Inactive, Inactive, Inactive],
      [Inactive, Inactive, Inactive, Inactive, Inactive],
      [Inactive, Inactive, Inactive, Inactive, Inactive],
      [Inactive, Inactive, Inactive, Inactive, Inactive],
    ])
  })
  test("starts a new line", () => {
    let next = {
      ...initial,
      currentNode: (1, 0),
      grid: [
        [Guessed("w"), Guessed("o"), Guessed("r"), Guessed("s"), Guessed("t")],
        [Inactive, Inactive, Inactive, Inactive, Inactive],
        [Inactive, Inactive, Inactive, Inactive, Inactive],
        [Inactive, Inactive, Inactive, Inactive, Inactive],
        [Inactive, Inactive, Inactive, Inactive, Inactive],
      ],
    }
    expect(next->Utils.insertValueIntoGrid(Some("b")))->toEqual([
      [Guessed("w"), Guessed("o"), Guessed("r"), Guessed("s"), Guessed("t")],
      [Guessed("b"), Inactive, Inactive, Inactive, Inactive],
      [Inactive, Inactive, Inactive, Inactive, Inactive],
      [Inactive, Inactive, Inactive, Inactive, Inactive],
      [Inactive, Inactive, Inactive, Inactive, Inactive],
    ])
  })
  test("deletes", () => {
    let next = {
      ...initial,
      currentNode: (0, 4),
      grid: [
        [Guessed("w"), Guessed("o"), Guessed("r"), Guessed("s"), Guessed("t")],
        [Inactive, Inactive, Inactive, Inactive, Inactive],
        [Inactive, Inactive, Inactive, Inactive, Inactive],
        [Inactive, Inactive, Inactive, Inactive, Inactive],
        [Inactive, Inactive, Inactive, Inactive, Inactive],
      ],
    }
    expect(next->Utils.insertValueIntoGrid(None))->toEqual([
      [Guessed("w"), Guessed("o"), Guessed("r"), Guessed("s"), Inactive],
      [Inactive, Inactive, Inactive, Inactive, Inactive],
      [Inactive, Inactive, Inactive, Inactive, Inactive],
      [Inactive, Inactive, Inactive, Inactive, Inactive],
      [Inactive, Inactive, Inactive, Inactive, Inactive],
    ])
  })
})

describe("reducer", () => {
  test("solves first word", () => {
    expect(
      {
        grid: [
          [Guessed("h"), Guessed("e"), Guessed("l"), Guessed("l"), Guessed("o")],
          [Inactive, Inactive, Inactive, Inactive, Inactive],
          [Inactive, Inactive, Inactive, Inactive, Inactive],
          [Inactive, Inactive, Inactive, Inactive, Inactive],
          [Inactive, Inactive, Inactive, Inactive, Inactive],
        ],
        currentNode: (0, 4),
        solution: "hello",
        invalidGuess: None,
        gameState: Playing,
        incorrectGuesses: [],
      }->Service.reducer(Solve),
    )->toEqual({
      grid: [
        [Correct("h"), Correct("e"), Correct("l"), Correct("l"), Correct("o")],
        [Inactive, Inactive, Inactive, Inactive, Inactive],
        [Inactive, Inactive, Inactive, Inactive, Inactive],
        [Inactive, Inactive, Inactive, Inactive, Inactive],
        [Inactive, Inactive, Inactive, Inactive, Inactive],
      ],
      currentNode: (0, 4),
      solution: "hello",
      invalidGuess: None,
      gameState: Won,
      incorrectGuesses: [],
    })
  })
  test("solves first word partially", () => {
    expect(
      {
        grid: [
          [Guessed("c"), Guessed("h"), Guessed("o"), Guessed("r"), Guessed("e")],
          [Inactive, Inactive, Inactive, Inactive, Inactive],
          [Inactive, Inactive, Inactive, Inactive, Inactive],
          [Inactive, Inactive, Inactive, Inactive, Inactive],
          [Inactive, Inactive, Inactive, Inactive, Inactive],
        ],
        currentNode: (0, 4),
        solution: "hello",
        gameState: Playing,
        invalidGuess: None,
        incorrectGuesses: [],
      }->Service.reducer(Solve),
    )->toEqual({
      grid: [
        [
          Incorrect("c"),
          PartialCorrect("h"),
          PartialCorrect("o"),
          Incorrect("r"),
          PartialCorrect("e"),
        ],
        [Inactive, Inactive, Inactive, Inactive, Inactive],
        [Inactive, Inactive, Inactive, Inactive, Inactive],
        [Inactive, Inactive, Inactive, Inactive, Inactive],
        [Inactive, Inactive, Inactive, Inactive, Inactive],
      ],
      currentNode: (1, 0),
      solution: "hello",
      invalidGuess: None,
      gameState: Playing,
      incorrectGuesses: ["c", "r"],
    })
  })
  test("returns invalid guess", () => {
    expect(
      {
        grid: [
          [Guessed("b"), Guessed("o"), Guessed("o"), Guessed("o"), Guessed("o")],
          [Inactive, Inactive, Inactive, Inactive, Inactive],
          [Inactive, Inactive, Inactive, Inactive, Inactive],
          [Inactive, Inactive, Inactive, Inactive, Inactive],
          [Inactive, Inactive, Inactive, Inactive, Inactive],
        ],
        currentNode: (0, 4),
        solution: "hello",
        gameState: Playing,
        invalidGuess: None,
        incorrectGuesses: [],
      }->Service.reducer(Solve),
    )->toEqual({
      grid: [
        [Guessed("b"), Guessed("o"), Guessed("o"), Guessed("o"), Guessed("o")],
        [Inactive, Inactive, Inactive, Inactive, Inactive],
        [Inactive, Inactive, Inactive, Inactive, Inactive],
        [Inactive, Inactive, Inactive, Inactive, Inactive],
        [Inactive, Inactive, Inactive, Inactive, Inactive],
      ],
      currentNode: (0, 4),
      solution: "hello",
      invalidGuess: Some("boooo"),
      gameState: Playing,
      incorrectGuesses: [],
    })
  })
})
