type node = (int, int)

type cell =
  | Inactive
  | Guessed(string)
  | PartialCorrect(string)
  | Correct(string)
  | Incorrect(string)

type row = array<cell>

type grid = array<row>
type gameState = Playing | Won | Lost

type state = {
  grid: grid,
  currentNode: node,
  solution: string,
  gameState: gameState,
  incorrectGuesses: array<string>,
}
type action = Guess(string) | Back | Solve | Invalid

let nextNode = state => {
  let (x, y) = state.currentNode
  let wordLength = state.solution->Js.String2.length
  let guessLength = state.grid->Js.Array2.length
  switch (x, y) {
  | (x, y) if y + 1 !== wordLength => (x, y + 1)
  | (x, y) if y + 1 === wordLength && x + 1 !== guessLength => (x + 1, 0)
  | _ => (0, 0)
  }
}

let lastNode = state => {
  let (x, y) = state.currentNode
  switch x {
  | x if x === 0 => (0, y)
  | _ => (x - 1, y)
  }
}

let insertValueIntoGrid = (state, value) => {
  let (x, y) = state.currentNode
  state.grid->Js.Array2.mapi((row, i) => {
    i !== x
      ? row
      : row->Js.Array2.mapi((cell, i) => {
          i !== y
            ? cell
            : switch value {
              | Some(value) => Guessed(value)
              | None => Inactive
              }
        })
  })
}

let solveGrid = state => {
  let (x, _) = state.currentNode
  state.grid->Js.Array2.mapi((row, i) => {
    i !== x
      ? row
      : row->Js.Array2.mapi((cell, i) => {
          switch cell {
          | Guessed(value) =>
            switch value {
            | v if state.solution->Js.String2.charAt(i) == v => Correct(value)
            | v if state.solution->Js.String2.includes(v) => PartialCorrect(value)
            | _ => Incorrect(value)
            }
          | _ => cell
          }
        })
  })
}

let completed = grid =>
  switch grid->Js.Array2.find(row =>
    row->Js.Array2.every(cell =>
      switch cell {
      | Correct(_) => true
      | _ => false
      }
    )
  ) {
  | Some(_) => true
  | _ => false
  }

let isLastGuess = state => state->nextNode === (0, 0)

let findIncorrect = (state, grid) => {
  let incorrect = ref(state.incorrectGuesses)
  grid->Js.Array2.forEach(row => {
    row->Js.Array2.forEach(cell => {
      switch cell {
      | Incorrect(v) if incorrect.contents->Js.Array2.includes(v) => ()
      | Incorrect(v) => incorrect := incorrect.contents->Js.Array2.concat([v])
      | _ => ()
      }
    })
  })
  incorrect.contents
}

let reducer = (state, action) => {
  switch action {
  | Guess(value) => {
      ...state,
      currentNode: state->nextNode,
      grid: state->insertValueIntoGrid(Some(value)),
    }
  | Back => {
      ...state,
      currentNode: state->lastNode,
      grid: state->insertValueIntoGrid(None),
    }
  | Solve => {
      let nextGrid = state->solveGrid
      let completed = nextGrid->completed
      {
        ...state,
        currentNode: state->nextNode,
        grid: nextGrid,
        gameState: completed ? Won : state->isLastGuess ? Lost : Playing,
        incorrectGuesses: state->findIncorrect(nextGrid),
      }
    }
  | Invalid => state
  }
}

let getInitial = solution => {
  grid: [
    [Inactive, Inactive, Inactive, Inactive, Inactive],
    [Inactive, Inactive, Inactive, Inactive, Inactive],
    [Inactive, Inactive, Inactive, Inactive, Inactive],
    [Inactive, Inactive, Inactive, Inactive, Inactive],
    [Inactive, Inactive, Inactive, Inactive, Inactive],
  ],
  currentNode: (0, 0),
  solution: solution,
  gameState: Playing,
  incorrectGuesses: [],
}

let words = ["hello", "ouphe", "chase"]

module GameContext = {
  include Context.Make({
    type context = (state, action => unit)
    let defaultValue = (getInitial(""), _ => ())
  })
}

module Provider = {
  @react.component
  let make = (~children) => {
    let initial = words[Js.Math.random_int(0, words->Js.Array2.length)]
    let (state, dispatch) = React.useReducer(reducer, getInitial(initial))

    <GameContext.Provider value=(state, dispatch)> children </GameContext.Provider>
  }
}
