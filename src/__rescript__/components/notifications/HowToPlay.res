open CoreComponents

@react.component
let make = () => {
  <BaseModal>
    <Row> <p> <Bold> {"How to play"->React.string} </Bold> </p> </Row>
    <TextRow>
      <p>
        {"Guess the "->React.string}
        <Bold> {"WORDLE "->React.string} </Bold>
        {"in six tries."->React.string}
      </p>
    </TextRow>
    <TextRow>
      <p>
        {"Each guess must be a valid five-letter word. Hit the enter button to submit."->React.string}
      </p>
    </TextRow>
    <TextRow>
      <p>
        {"After each guess, the color of the tiles will change to show how close your guess was to the word."->React.string}
      </p>
    </TextRow>
    <Divider />
    <TextRow> <p> <Bold> {"Examples"->React.string} </Bold> </p> </TextRow>
    <TextRow>
      <GameRow row=[Correct("o"), Incorrect("u"), Incorrect("p"), Incorrect("h"), Incorrect("e")] />
    </TextRow>
    <TextRow>
      <p>
        {"The letter "->React.string}
        <Bold> {"o "->React.string} </Bold>
        {"is in the word and in the correct spot. "->React.string}
        <Bold> {"u, p, h"->React.string} </Bold>
        {",and "->React.string}
        <Bold> {"e "->React.string} </Bold>
        {"are not in the word in any spots."->React.string}
      </p>
    </TextRow>
    <TextRow>
      <GameRow
        row=[
          Incorrect("p"),
          PartialCorrect("i"),
          Incorrect("x"),
          PartialCorrect("i"),
          Incorrect("e"),
        ]
      />
    </TextRow>
    <TextRow>
      <p>
        {"The letter "->React.string}
        <Bold> {"i "->React.string} </Bold>
        {"is in the word but in neither spot. "->React.string}
        <Bold> {"p, x"->React.string} </Bold>
        {",and "->React.string}
        <Bold> {"e "->React.string} </Bold>
        {"are not in the word in any spots."->React.string}
      </p>
    </TextRow>
    <Divider />
    <TextRow>
      <p>
        <Bold>
          {"Made in homage to the real "->React.string}
          <a target="_blank" href="https://www.nytimes.com/games/wordle/index.html">
            {"wordle."->React.string}
          </a>
        </Bold>
      </p>
    </TextRow>
    <TextRow>
      <p>
        <Bold>
          {"You can take a look at the source code "->React.string}
          <a target="_blank" href="https://github.com/josh-klimaszewski/rescript-wordle">
            {"here."->React.string}
          </a>
        </Bold>
      </p>
    </TextRow>
  </BaseModal>
}
