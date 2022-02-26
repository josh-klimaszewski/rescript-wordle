@react.component
let make = () => {
  let (state, _dispatch) = Game.GameContext.use()

  Js.log(state)
  React.null
}
