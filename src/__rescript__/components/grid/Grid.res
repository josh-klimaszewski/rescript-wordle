open CoreComponents

@react.component
let make = () => {
  let (state, _dispatch) = GameService.Context.use()

  state.grid
  ->Js.Array2.mapi((row, x) =>
    <Row key={x->Js.Int.toString}>
      {row
      ->Js.Array2.mapi((_, y) => <GameCell key={y->Js.Int.toString} node=(x, y) />)
      ->React.array}
    </Row>
  )
  ->React.array
}
