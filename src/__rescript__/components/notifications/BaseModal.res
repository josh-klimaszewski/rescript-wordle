open CoreComponents

module TextWrapper = %styled.div(`
 padding: 15px;
  `)

module ButtonWrapper = %styled.div(`
  display: flex;
  justify-content: flex-end;
  `)

module Button = %styled.div(`
  display: flex;
  align-self: flex-end;
  font-weight: bold;
  color: black;
  text-decoration: none;
  cursor: pointer;
 
  `)

@react.component
let make = (~children) => {
  let (_state, dispatch) = GameService.Context.use()

  <Modal>
    <TextWrapper>
      <ButtonWrapper>
        <Button onClick={_e => dispatch(Next)}> {"X"->React.string} </Button>
      </ButtonWrapper>
      children
    </TextWrapper>
  </Modal>
}
