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

let reducer = (action: action, state: state) => {
  switch action {
  | Guess({node: (incomingRow, incomingColumn), value}) => {
      ...state,
      grid: state.grid->Js.Array2.map(row => {
        row->Js.Array2.map(cell => {
          switch cell {
          | Inactive({node: (x, y)}) when x === incomingRow && y === incomingColumn =>
            Guessed({node: (x, y), value: value})
          | _ => cell
          }
        })
      }),
    }
  | Solve({node: (incomingRow, _incomingColumn)}) => {
      ...state,
      grid: state.grid->Js.Array2.map(row => {
        switch row {
        | row when state.grid->Js.Array2.findIndex(r => r == row) == incomingRow => []
        // let guess = row->Js.Array2.reduce((acc, cur) => acc :+= cur)

        | _ => row
        }
        // switch state.grid->Js.Array2.findIndex(row => row === incomingRow) {
        // | Some(x) when x === incomingRow => row
        // | _ => row
        // }
      }),
    }
  | Invalid => state
  }
}

// let word_length = 5
// let guess_length = 5

// type cell =
//   | Inactive
//   | Active(string)
//   | Partial(string)
//   | Correct(string)

// type grid = array<array<cell>>

// type node = (int, int)

// let getCell = (grid: grid, (x, y): node) => grid[x][y]
// let getNextCell = (grid: grid, (x, y): node) => {
//   switch y === word_length - 1 {
//   | false => grid[x][y + 1]
//   | true => switch x === guess_length - 1 {
//     | false => grid[x + 1][0]
//     | true => grid[0][0]
//     }
//   }
// }

// type state = {
//   grid: grid,
//   activeCell: node,
// }

// type action = Invalid | Input(string) | Solve

// let reducer = (state, action) => {
//   switch action {
//   | Input(string) => {
//       let cell = state.grid->getCell
//       {
//         ...state,
//         grid: state.grid->Js.Array2.map(row => {
//           row
//         }),
//       }
//     }
//   | Invalid
//   | _ => state
//   }
// }
