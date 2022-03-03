open CoreComponents

module Wrapper = %styled.div(`
  display: flex;
  align-items: center;
  justify-content: center;
  height: 30px
  `)

@react.component
let make = () => {
  let (state, _dispatch) = GameService.Context.use()

  <Wrapper>
    <Bold>
      {switch (state.gameState, state.invalidGuess) {
      | (Playing, Some(guess)) => `Couldn't recognize ${guess} as a valid word`->React.string
      | (Won, _) => "Congrats, you won!"->React.string
      | (Lost, _) => `You lost (correct answer was ${state.solution})`->React.string
      | _ => React.null
      }}
    </Bold>
  </Wrapper>
}
