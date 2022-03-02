@react.component
let make = () => {
  let (state, _dispatch) = Service.Context.use()

  switch state.gameState {
  | Initial => <HowToPlay />
  | _ => React.null
  }
}
