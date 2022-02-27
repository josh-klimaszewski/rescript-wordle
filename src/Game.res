open Models

let reducer = (state, action) => {
  switch (action, state.gameState) {
  | (Guess(value), Playing) => {
      ...state,
      currentNode: state->Utils.readyToSolve ? state.currentNode : state->Utils.nextNode,
      grid: state->Utils.insertValueIntoGrid(Some(value)),
      invalidGuess: None,
    }

  | (Back, Playing) if state->Utils.handlingBackSpaceWhenReadyToSolve => {
      ...state,
      invalidGuess: None,
      grid: state->Utils.insertValueIntoGrid(None),
    }

  | (Back, Playing) => {
      let lastNode = state->Utils.lastNode
      {
        ...state,
        grid: {...state, currentNode: lastNode}->Utils.insertValueIntoGrid(None),
        currentNode: lastNode,
      }
    }

  | (Solve, Playing) if state->Utils.handlingInvalidSolve => {
      ...state,
      invalidGuess: Some(state->Utils.buildGuess),
    }

  | (Solve, Playing) if state->Utils.handlingWinningSolve => {
      ...state,
      gameState: Won,
      grid: state->Utils.solveGrid,
    }

  | (Solve, Playing) if state->Utils.handlingLosingSolve => {
      ...state,
      gameState: Lost,
      grid: state->Utils.solveGrid,
    }

  | (Solve, Playing) if state->Utils.readyToSolve => {
      let nextGrid = state->Utils.solveGrid
      {
        ...state,
        currentNode: state->Utils.nextNode,
        grid: nextGrid,
        incorrectGuesses: state->Utils.findIncorrect(nextGrid),
      }
    }
  | _ => state
  }
}

module GameContext = {
  include Context.Make({
    type context = (state, action => unit)
    let defaultValue = (Utils.getInitial(""), _ => ())
  })
}

module Provider = {
  @react.component
  let make = (~children) => {
    let (state, dispatch) = React.useReducer(
      reducer,
      Constants.words->Utils.randomWord->Utils.getInitial,
    )

    <GameContext.Provider value=(state, dispatch)> children </GameContext.Provider>
  }
}
