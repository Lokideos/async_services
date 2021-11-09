import React from 'react'
import { Router, Route, Switch } from 'react-router-dom'
import SignUp from "./SignUp";
import Profile from "./Profile";
import history from '../history'

const App = () => {
  return(
    <div className="ui container">
      <Router history={history}>
        <Switch>
          <Route path="/" exact component={Profile} />
          <Route path="/signup" exact component={SignUp} />
        </Switch>
      </Router>
    </div>
  )
}

export default App
