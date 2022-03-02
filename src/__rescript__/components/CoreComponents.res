module Wrapper = %styled.div(`
    display: flex;
    flex-direction: column;
    gap: 15px;
    margin-top: 60px;
  `)

module Row = %styled.div(`
   display: flex;
   justify-content: center;
   gap: 15px;
   font-weight: bold;
   color: #F7EDE2;
  `)

module Cell = %styled.div(
  (~background) =>
    `
    width: 58px;
    height: 58px;
    background: $(background);
    border-radius: 10%;
    border: 2px solid black;
    display: flex;
    justify-content: center;
    align-items: center;
    color: black;
  `
)

module Modal = %styled.div(`
    position: fixed;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    width: 300px;
    height: 600px;
    max-width: 100%;
    max-height: 100%;
    display: flex;
    flex-direction: column;
    gap: 15px;
    background: white;
  `)
