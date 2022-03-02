@react.component
let make = () => {
  let (state, _dispatch) = GameService.Context.use()

  switch state.gameState {
  | Initial => <HowToPlay />
  | _ => React.null
  }
}
