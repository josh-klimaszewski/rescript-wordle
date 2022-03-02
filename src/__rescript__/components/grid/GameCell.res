open CoreComponents

@react.component
let make = (~node: Models.node) => {
  let (state, _dispatch) = GameService.Context.use()

  switch state->Utils.findCell(node) {
  | Inactive => <Cell background=Constants.Color.white />
  | Guessed(v) => <Cell background=Constants.Color.white> {v->React.string} </Cell>
  | Incorrect(v) => <Cell background=Constants.Color.red> {v->React.string} </Cell>
  | PartialCorrect(v) => <Cell background=Constants.Color.yellow> {v->React.string} </Cell>
  | Correct(v) => <Cell background=Constants.Color.green> {v->React.string} </Cell>
  }
}