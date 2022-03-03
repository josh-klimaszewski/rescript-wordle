open CoreComponents

@react.component
let make = () => {
  let (state, _dispatch) = GameService.Context.use()

  <BaseModal>
    <TextRow> {`You lost (correct answer was ${state.solution})`->React.string} </TextRow>
  </BaseModal>
}
