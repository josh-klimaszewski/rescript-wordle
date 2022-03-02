open CoreComponents

@react.component
let make = () => {
  let (_state, dispatch) = Service.Context.use()

  <Modal>
    <Row> <div onClick={_e => dispatch(CloseNotification)}> {"X"->React.string} </div> </Row>
    <Row> {"How to play"->React.string} </Row>
  </Modal>
}
