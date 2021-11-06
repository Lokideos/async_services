import {
  SIGN_IN,
  SIGN_OUT,
  SIGN_UP
} from "../actions/types"

const INITIAL_STATE = {
  isSignedIn: null,
  name: null,
  email: null
}

export default (state = INITIAL_STATE, action) => {
  switch (action.type) {
    case SIGN_IN:
      return {
        ...state,
        isSignedIn: true,
        name: action.payload.data.attributes.name,
        email: action.payload.data.attributes.email
      }
    case SIGN_OUT:
      return {
        ...state,
        isSignedIn: false,
        name: null,
        email: null
      }
    case SIGN_UP:
      return {
        ...state,
        isSignedIn: true,
        name: action.payload.data.attributes.name,
        email: action.payload.data.attributes.email
      }
    default:
      return state
  }
}
