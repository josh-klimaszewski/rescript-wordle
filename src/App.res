%%raw(`import './App.css';`)

@react.component
let make = () => {
  <Game.Provider> <div className="App"> {"wordle"->React.string} <Board /> </div> </Game.Provider>
}
