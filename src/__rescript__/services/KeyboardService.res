type document = {
  addEventListener: (string, ReactEvent.Keyboard.t => unit) => unit,
  removeEventListener: (string, ReactEvent.Keyboard.t => unit) => unit,
}

@val external document: document = "document"

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
  let (_state, dispatch) = GameService.Context.use()

  let onKeyDown = event => {
    let key = event->ReactEvent.Keyboard.key->Js.String2.toLowerCase
    let metaKey = event->ReactEvent.Keyboard.metaKey
    let ctrlKey = event->ReactEvent.Keyboard.ctrlKey

    switch (metaKey, ctrlKey, key) {
    | (true, _, _)
    | (_, true, _) => ()
    | (_, _, "enter") => dispatch(Next)
    | (_, _, "backspace") => dispatch(Back)
    | (_, _, k) if k->isAlpha => dispatch(Guess(k))
    | _ => ()
    }
  }

  React.useEffect0(() => {
    document.addEventListener("keydown", onKeyDown)
    Some(
      () => {
        document.removeEventListener("keydown", onKeyDown)
      },
    )
  })
}
