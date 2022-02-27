@val external document: 'a = "document"

let isAlpha = key =>
  switch (key, key->Js.String2.length) {
  | (k, 1)
    if k
    ->Js.String2.match_(%re("/^[A-Z]+$/i"))
    ->Belt.Option.getWithDefault([])
    ->Js.Array2.length > 0 => true
  | _ => false
  }

let use = () => {
  let (_state, dispatch) = Game.GameContext.use()
  let onKeyDown = event => {
    let key = ReactEvent.Keyboard.key(event)->Js.String2.toLowerCase
    let metaKey = ReactEvent.Keyboard.metaKey(event)
    switch (metaKey, key) {
    | (true, _) => ()
    | (_, "enter") => dispatch(Solve)
    | (_, "backspace") => dispatch(Back)
    | (_, k) if k->isAlpha => dispatch(Guess(k))
    | _ => ()
    }
  }
  React.useEffect0(() => {
    document["addEventListener"]("keydown", onKeyDown)
    Some(
      () => {
        document["removeEventListener"]("keydown", onKeyDown)
      },
    )
  })
}
