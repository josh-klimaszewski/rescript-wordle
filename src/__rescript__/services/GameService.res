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

  | (Next, Playing) if state->Utils.handlingInvalidSolve => {
      ...state,
      invalidGuess: Some(state->Utils.buildGuess),
    }

  | (Next, Playing) if state->Utils.handlingWinningSolve => {
      ...state,
      gameState: Won,
      grid: state->Utils.solveGrid,
    }

  | (Next, Playing) if state->Utils.handlingLosingSolve => {
      ...state,
      gameState: Lost,
      grid: state->Utils.solveGrid,
    }

  | (Next, Playing) if state->Utils.readyToSolve => {
      let nextGrid = state->Utils.solveGrid
      {
        ...state,
        currentNode: state->Utils.nextNode,
        grid: nextGrid,
        incorrectGuesses: state->Utils.findIncorrect(nextGrid),
      }
    }

  | (Next, Initial) => {
      ...state,
      gameState: Playing,
    }

  | (Next, Lost) => {
      let nextGame = Constants.words->Utils.randomWord->Utils.getInitial
      {
        ...nextGame,
        gameState: Playing,
      }
    }

  | (SeeInitial, Playing) => {
      ...state,
      gameState: Initial,
    }
  | _ => state
  }
}

module Context = {
  include ReactContext.Make({
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

    <Context.Provider value=(state, dispatch)> children </Context.Provider>
  }
}
