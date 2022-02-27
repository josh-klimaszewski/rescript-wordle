module Cell = %styled.div(
  (~background) =>
    `
    width: 58px;
    height: 58px;
    background: $(background);
    border-radius: 10%;
    border: 2px solid black;
    display: flex;
    justify-content: center;
    align-items: center;
    color: black;
  `
)

@react.component
let make = (~node: Models.node) => {
  let (state, _dispatch) = Game.GameContext.use()

  switch state->Utils.findCell(node) {
  | Inactive => <Cell background=Color.white />
  | Guessed(v) => <Cell background=Color.white> {v->React.string} </Cell>
  | Incorrect(v) => <Cell background=Color.red> {v->React.string} </Cell>
  | PartialCorrect(v) => <Cell background=Color.yellow> {v->React.string} </Cell>
  | Correct(v) => <Cell background=Color.green> {v->React.string} </Cell>
  }
}
