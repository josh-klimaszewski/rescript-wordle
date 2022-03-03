open CoreComponents

module Background = %styled.div(
  (~bg) =>
    `
  background-color: $(bg);
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  `
)

@react.component
let make = () => {
  <GameService.Provider>
    <Background bg=Constants.Color.white>
      <Notifications /> <Wrapper> <Header /> <Grid /> <Messages /> <Keyboard /> </Wrapper>
    </Background>
  </GameService.Provider>
}
