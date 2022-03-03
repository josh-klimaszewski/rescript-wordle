open CoreComponents

@react.component
let make = () => {
  let (state, _dispatch) = GameService.Context.use()

  state.grid
  ->Js.Array2.mapi((row, x) => <Row key={x->Js.Int.toString}> <GameRow row /> </Row>)
  ->React.array
}
