open CoreComponents

module Background = %styled.div(`
  background-color: #282c34;
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  `)

@react.component
let make = () => {
  <GameService.Provider>
    <Background>
      <Notifications /> <Wrapper> <Header /> <Grid /> <Keyboard /> <Messages /> </Wrapper>
    </Background>
  </GameService.Provider>
}
