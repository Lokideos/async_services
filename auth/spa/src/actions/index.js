import history from "../history";
import { useCookies } from 'react-cookie';
import auth from "../apis/auth"
import {
  SIGN_IN,
  SIGN_OUT,
  SIGN_UP
} from "./types"

export const signIn = (userId) => {
  return {
    type: SIGN_IN,
    payload: userId
  }
}

export const signOut = () => {
  return {
    type: SIGN_OUT
  }
}

export const signUp = formValues => async (dispatch, getState) => {
  const response = await auth.post(
    '/signup',
    { ...formValues}
  )

  dispatch({
    type: SIGN_UP,
    payload: response.data
  })
  history.push('/')
}
