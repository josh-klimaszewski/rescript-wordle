type node = (int, int)

type cell =
  | Inactive({node: node})
  | Guessed({node: node, value: string})
  | PartialCorrect({node: node, value: string})
  | Correct({node: node, value: string})

type grid = array<array<cell>>

type state = {
  grid: grid,
  solution: string,
  completed: bool,
}

type action = Guess({node: node, value: string}) | Solve({node: node}) | Invalid

let isRowToSolve = (row, state, index) => state.grid->Js.Array2.findIndex(r => r == row) == index

let shouldSolve = (state, index) => {
  index == state.solution->Js.String2.length - 1
}

let findNewCellFromGuess = (cell, incomingRow, incomingColumn, value) => {
  switch cell {
  | Inactive({node: (x, y)}) when x === incomingRow && y === incomingColumn =>
    Guessed({node: (x, y), value: value})
  | _ => cell
  }
}

let findNewStateFromGuess = (state, node, value) => {
  let (incomingRow, incomingColumn) = node
  let newState = {
    ...state,
    grid: state.grid->Js.Array2.map(row => {
      row->Js.Array2.map(cell => cell->findNewCellFromGuess(incomingRow, incomingColumn, value))
    }),
  }
  newState
}

let findNewCellFromSolution = (cell, state) => {
  switch cell {
  | Guessed({node: (x, y), value}) =>
    switch value {
    | v when state.solution->Js.String2.charAt(y) == v => Correct({node: (x, y), value: value})
    | v when state.solution->Js.String2.includes(v) => PartialCorrect({node: (x, y), value: value})
    | _ => cell
    }
  | _ => cell
  }
}

let findNewGridForSolution = (state, index) =>
  state.grid->Js.Array2.map(row => {
    switch row {
    | row when row->isRowToSolve(state, index) =>
      row->Js.Array2.map(cell => cell->findNewCellFromSolution(state))
    | _ => row
    }
  })

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

let rec reducer = (action, state) => {
  switch action {
  | Guess({node, value}) => {
      let newState = state->findNewStateFromGuess(node, value)
      switch node {
      | (_, col) when state->shouldSolve(col) =>
        reducer(Solve({node: node}), newState)
      | _ => newState
      }
    }
  | Solve({node: (incomingRow, _incomingColumn)}) => {
      let newGrid = state->findNewGridForSolution(incomingRow)
      let completed = newGrid->completed
      {
        ...state,
        grid: newGrid,
        completed: completed,
      }
    }
  | Invalid => state
  }
}
