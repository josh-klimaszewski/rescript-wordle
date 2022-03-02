type node = (int, int)

type cell =
  | Inactive
  | Guessed(string)
  | Incorrect(string)
  | PartialCorrect(string)
  | Correct(string)

type row = array<cell>

type grid = array<row>

type gameState = Initial | Playing | Won | Lost

type state = {
  grid: grid,
  currentNode: node,
  solution: string,
  gameState: gameState,
  invalidGuess: option<string>,
  incorrectGuesses: array<string>,
}
type action = Guess(string) | Back | Next 
