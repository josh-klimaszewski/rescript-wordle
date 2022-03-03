open CoreComponents

module TextWrapper = %styled.div(`
 padding: 15px;
  `)

module ButtonWrapper = %styled.div(`
  display: flex;
  align-items: center;
  justify-content: space-between;
  cursor: pointer
  `)

module Button = %styled.div(`
  font-weight: bold;
  color: black;
  text-decoration: none;
 
  `)

@react.component
let make = (~children, ~title) => {
  let (_state, dispatch) = GameService.Context.use()

  let onClick = _e => dispatch(Next)

  <Modal bg=Constants.Color.white>
    <TextWrapper>
      <ButtonWrapper onClick>
        <div /> <p> <Bold> {title->React.string} </Bold> </p> <Button> {"x"->React.string} </Button>
      </ButtonWrapper>
      children
    </TextWrapper>
  </Modal>
}
