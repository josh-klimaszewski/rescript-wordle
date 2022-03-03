open CoreComponents

@react.component
let make = (~cell: Models.cell) => {
  switch cell {
  | Inactive => <Cell background=Constants.Color.white />
  | Guessed(v) => <Cell background=Constants.Color.white> {v->React.string} </Cell>
  | Incorrect(v) => <Cell background=Constants.Color.red> {v->React.string} </Cell>
  | PartialCorrect(v) => <Cell background=Constants.Color.yellow> {v->React.string} </Cell>
  | Correct(v) => <Cell background=Constants.Color.green> {v->React.string} </Cell>
  }
}
