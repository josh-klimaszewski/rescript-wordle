module Background = %styled.div(`
  text-align: center;
  background-color: #282c34;
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  `)

@react.component
let make = () => {
  <Game.Provider> <Background> <Board /> </Background> </Game.Provider>
}
