%%raw(`import './Index.css';`)

let fallback = <div> {React.string("...")} </div>
let app = <React.Suspense fallback> <App key="app" /> </React.Suspense>

switch ReactDOM.querySelector("#root") {
| Some(root) => ReactDOM.render(app, root)
| None => ()
}
