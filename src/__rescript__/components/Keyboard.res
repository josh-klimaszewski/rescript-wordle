open CoreComponents

@react.component
let make = () => {
  let (state, _dispatch) = GameService.Context.use()
  KeyboardService.use()

  <Row>
    {state.incorrectGuesses
    ->Js.Array2.mapi((g, x) => <div key={x->Js.Int.toString}> {g->React.string} </div>)
    ->React.array}
  </Row>
}
