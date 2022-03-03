open Models

module Key = %styled.div(
  (~bg) =>
    `
    background: $(bg);
    border: 2px solid black;
    display: flex;
    justify-content: center;
    align-items: center;
    width: 30px;
    height: 60px;
    gap: 25px;
  `
)

module EnterKey = %styled.div(`
    border: 2px solid black;
    display: flex;
    justify-content: center;
    align-items: center;
    width: 108px;
    height: 60px;
    gap: 2px;
  `)

let getCompletedKeys = grid => {
  let keys = ref([])
  grid->Js.Array2.forEach(row => {
    row->Js.Array2.forEach(cell => {
      switch cell {
      | Correct(v) =>
        switch keys {
        | keys if keys.contents->Js.Array2.includes(v) => ()
        | _ => keys := keys.contents->Js.Array2.concat([v])
        }
      | _ => ()
      }
    })
  })
  keys.contents
}

@react.component
let make = (~v: string) => {
  let (state, dispatch) = GameService.Context.use()

  let bg = switch (
    state.incorrectGuesses->Js.Array2.find(g => g == v),
    state.grid->getCompletedKeys->Js.Array2.find(g => g == v),
  ) {
  | (Some(_), _) => Constants.Color.red
  | (_, Some(_)) => Constants.Color.green
  | _ => Constants.Color.white
  }

  let onClick = _e =>
    switch v {
    | "backspace" => dispatch(Back)
    | "enter" => dispatch(Next)
    | _ => dispatch(Guess(v))
    }

  switch v {
  | "backspace" => <Key bg=Constants.Color.white onClick> {"<-"->React.string} </Key>
  | "enter" => <EnterKey onClick> {v->React.string} </EnterKey>
  | _ => <Key bg onClick> {v->React.string} </Key>
  }
}
