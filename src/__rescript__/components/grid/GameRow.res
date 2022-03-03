open Models

@react.component
let make = (~row: array<cell>) => {
  row->Js.Array2.mapi((cell, y) => <GameCell key={y->Js.Int.toString} cell />)->React.array
}
