open Models

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

let readyToSolve = state => {
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

let getInitial = solution => {
  grid: Belt.Array.make(6, Belt.Array.make(solution->Js.String2.length, Inactive)),
  currentNode: (0, 0),
  solution: solution,
  gameState: Initial,
  invalidGuess: None,
  incorrectGuesses: [],
}

let randomWord = words => {
  words[0->Js.Math.random_int(words->Js.Array2.length)]
}

let handlingBackSpaceWhenReadyToSolve = state =>
  state->readyToSolve && state->currentCharacterIsGuessed

let handlingInvalidSolve = state => state->readyToSolve && state->buildGuess->validGuess == false

let handlingWinningSolve = state => state->readyToSolve && state->solveGrid->completed

let handlingLosingSolve = state => state->handlingWinningSolve == false && state->isLastGuess
