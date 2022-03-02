open CoreComponents

module Background = %styled.div(`
  text-align: center;
  background-color: #282c34;
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  `)

@react.component
let make = () => {
  <Service.Provider>
    <Background>
      <Notifications /> <Wrapper> <Header /> <Grid /> <Keyboard /> <Messages /> </Wrapper>
    </Background>
  </Service.Provider>
}
