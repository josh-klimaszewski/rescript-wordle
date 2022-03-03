module Wrapper = %styled.div(`
    margin-top: 15px;
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 5px;
  `)

module KeyboardRow = %styled.div(`
    display: flex;
    gap: 5px
  `)

@react.component
let make = () => {
  KeyboardService.use()

  <Wrapper>
    {Constants.keyboardKeys
    ->Js.Array2.mapi((level, x) =>
      <KeyboardRow key={x->Js.Int.toString}>
        {level->Js.Array2.mapi((v, y) => <Key key={y->Js.Int.toString} v />)->React.array}
      </KeyboardRow>
    )
    ->React.array}
  </Wrapper>
}
