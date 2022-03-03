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
  `)

module TextRow = %styled.div(`
   display: flex;
   justify-content: flex-start;
   gap: 15px;
  `)

module Text = %styled.p(`
    color: #F7EDE2;
    font-weight: bold;
  `)

module Cell = %styled.div(
  (~background) =>
    `
    font-weight: bold;
    width: 58px;
    height: 58px;
    background: $(background);
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
    width: 820px;
    height: 820px;
    max-width: 100%;
    max-height: 100%;
    padding: 15px;
    display: flex;
    flex-direction: column;
    gap: 15px;
    background: white;
    z-index: 10;
    color: black;
  `)

module Bold = %styled.span(`
    font-weight: bold;
  `)

module Divider = %styled.div(`
    height: 1px;
    width: 100%;
    background: lightgrey
  `)
