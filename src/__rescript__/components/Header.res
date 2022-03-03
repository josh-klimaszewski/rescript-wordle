open CoreComponents
open Models

module TextWrapper = %styled.div(`
    padding-top: 15px;
    padding-left: 15px;
    padding-right: 15px;
    display: flex;
    justify-content: space-between;
    align-items: center;
  `)

@react.component
let make = () => {
  let (_state, dispatch) = GameService.Context.use()

  let onClick = _e => dispatch(SeeInitial)
  <TextWrapper>
    <div />
    <p> <Bold> {"w o r d l e c l o n e"->React.string} </Bold> </p>
    <Bold onClick> {"? "->React.string} </Bold>
  </TextWrapper>
}
