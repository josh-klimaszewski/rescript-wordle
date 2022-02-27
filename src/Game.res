type node = (int, int)

type cell =
  | Inactive
  | Guessed(string)
  | Incorrect(string)
  | PartialCorrect(string)
  | Correct(string)

type row = array<cell>

type grid = array<row>
type gameState = Playing | Won | Lost

type state = {
  grid: grid,
  currentNode: node,
  solution: string,
  gameState: gameState,
  invalidGuess: option<string>,
  incorrectGuesses: array<string>,
}
type action = Guess(string) | Back | Solve

let nextNode = state => {
  let (x, y) = state.currentNode
  let wordLength = state.solution->Js.String2.length
  let guessLength = state.grid->Js.Array2.length
  switch (x, y) {
  | (x, y) if y + 1 !== wordLength => (x, y + 1)
  | (x, y) if y + 1 === wordLength && x + 1 !== guessLength => (x + 1, 0)
  | (x, y) => (x, y)
  }
}

let lastNode = state => {
  switch state.currentNode {
  | (_, 0) => state.currentNode
  | (x, y) => (x, y - 1)
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
              | Some(value) =>
                state.incorrectGuesses->Js.Array2.includes(value)
                  ? Incorrect(value)
                  : Guessed(value)
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

let onLastCharacter = state => {
  let (_, y) = state.currentNode
  state.solution->Js.String2.length - 1 === y
}

let currentCharacterIsGuessed = state => {
  let (x, y) = state.currentNode
  switch state.grid[x][y] {
  | Incorrect(_)
  | Guessed(_) => true
  | _ => false
  }
}

let isLastGuess = state => {
  switch state.currentNode {
  | (x, _) if state.grid->Js.Array2.length - 1 === x => true
  | _ => false
  }
}

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

let findCell = (state, (x, y): node) => state.grid[x][y]

let buildGuess = state => {
  let (x, _) = state.currentNode
  state.grid[x]
  ->Js.Array2.map(cell => {
    switch cell {
    | Incorrect(v)
    | Guessed(v) => v
    | _ => ""
    }
  })
  ->Js.Array2.joinWith("")
}

let validGuess = guess =>
  Constants.valid->Js.Array2.concat(Constants.words)->Js.Array2.includes(guess)

let reducer = (state, action) => {
  switch (state.gameState, state->onLastCharacter, action) {
  | (Playing, _, Guess(value)) => {
      ...state,
      currentNode: state->onLastCharacter ? state.currentNode : state->nextNode,
      grid: state->insertValueIntoGrid(Some(value)),
      invalidGuess: None,
    }
  | (Playing, _, Back) =>
    switch state {
    | state if state->onLastCharacter && state->currentCharacterIsGuessed => {
        ...state,
        invalidGuess: None,
        grid: state->insertValueIntoGrid(None),
      }
    | _ => {
        let lastNode = state->lastNode
        {
          ...state,
          grid: {...state, currentNode: lastNode}->insertValueIntoGrid(None),
          currentNode: lastNode,
        }
      }
    }
  | (Playing, true, Solve) =>
    let nextGrid = state->solveGrid
    switch (nextGrid->completed, state->isLastGuess) {
    | (true, _) => {
        ...state,
        currentNode: state->nextNode,
        grid: nextGrid,
        gameState: Won,
      }
    | (false, true) => {
        ...state,
        grid: nextGrid,
        gameState: Lost,
      }
    | (false, false) => {
        let guess = state->buildGuess
        switch guess->validGuess {
        | true => {
            ...state,
            currentNode: state->nextNode,
            grid: nextGrid,
            incorrectGuesses: state->findIncorrect(nextGrid),
          }
        | false => {
            ...state,
            invalidGuess: Some(guess),
          }
        }
      }
    }
  | _ => state
  }
}

let getInitial = solution => {
  grid: Belt.Array.make(6, Belt.Array.make(solution->Js.String2.length, Inactive)),
  currentNode: (0, 0),
  solution: solution,
  gameState: Playing,
  invalidGuess: None,
  incorrectGuesses: [],
}

let randomWord = words => {
  words[0->Js.Math.random_int(words->Js.Array2.length)]
}

module GameContext = {
  include Context.Make({
    type context = (state, action => unit)
    let defaultValue = (getInitial(""), _ => ())
  })
}

module Provider = {
  @react.component
  let make = (~children) => {
    let (state, dispatch) = React.useReducer(reducer, Constants.words->randomWord->getInitial)

    <GameContext.Provider value=(state, dispatch)> children </GameContext.Provider>
  }
}
