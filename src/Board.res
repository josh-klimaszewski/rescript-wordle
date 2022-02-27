module Wrapper = %styled.div(`
    display: flex;
    flex-direction: column;
    gap: 15px;
    margin-top: 60px;
  `)

module Row = %styled.div(`
   display: flex;
   justify-content: center;
   gap: 15px;
   font-weight: bold;
   color: #F7EDE2;
  `)

@react.component
let make = () => {
  let (state, _dispatch) = Game.GameContext.use()
  Js.log(state.currentNode)
  KeyboardListener.use()
  <Wrapper>
    {state.grid
    ->Js.Array2.mapi((row, x) =>
      <Row key={x->Js.Int.toString}>
        {row->Js.Array2.mapi((_, y) => <Cell key={y->Js.Int.toString} node=(x, y) />)->React.array}
      </Row>
    )
    ->React.array}
    <Row>
      {state.incorrectGuesses
      ->Js.Array2.mapi((g, x) => <div key={x->Js.Int.toString}> {g->React.string} </div>)
      ->React.array}
    </Row>
    <Row>
      {switch (state.gameState, state.invalidGuess) {
      | (Playing, None) => React.null
      | (Playing, Some(guess)) => `Couldn't recognize ${guess} as a valid word`->React.string
      | (Won, _) => "Congrats, you won!"->React.string
      | (Lost, _) => `You lost (correct answer was ${state.solution})`->React.string
      }}
    </Row>
  </Wrapper>
}
