open CoreComponents

module Background = %styled.div(
  (~bg) =>
    `
  background-color: $(bg);
  display: flex;
  flex-direction: column;
  `
)

@react.component
let make = () => {
  <GameService.Provider>
    <content className="min-h-screen">
      <Background bg=Constants.Color.white>
        <Notifications /> <Wrapper> <Header /> <Grid /> <Messages /> <Keyboard /> </Wrapper>
      </Background>
    </content>
  </GameService.Provider>
}
