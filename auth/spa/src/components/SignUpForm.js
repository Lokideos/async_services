import React from "react";
import { Form, Field } from "react-final-form";

const SignUpForm = (props) => {
  const renderError = ({ error, touched }) => {
    if (touched && error) {
      return (
        <div className="ui error message">
          <div className="header">{error}</div>
        </div>
      );
    }
  };

  const renderInput = ({ input, label, meta }) => {
    const className = `field ${meta.error && meta.touched ? "error" : ""}`;
    return (
      <div className={className}>
        <label>{label}</label>
        <input {...input} autoComplete="off" />
        {renderError(meta)}
      </div>
    );
  };

  const onSubmit = (formValues) => {
    props.onSubmit(formValues);
  };

  return (
    <Form
      onSubmit={onSubmit}
      validate={(formValues) => {
        const errors = {};
        const regexEmail = /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/

        if (!formValues.name) {
          errors.name = "Name can not be blank";
        }

        if (!formValues.email) {
          errors.email = "Email can not be blank";
        }

        if (formValues.email) {
          if (!formValues.email.match(regexEmail)) {
            errors.email = "Please use correct email"
          }
        }

        if (!formValues.password) {
          errors.password = "Password can not be blank";
        }

        if (formValues.password !== formValues.passwordConfirmation) {
          errors.passwordConfirmation = "Passwords do not match"
        }

        return errors;
      }}
      render={({ handleSubmit }) => (
        <form onSubmit={handleSubmit} className="ui form error">
          <Field name="name" component={renderInput} label="Enter Name" />
          <Field
            name="email"
            component={renderInput}
            label="Email"
          />
          <Field
            name="password"
            component={renderInput}
            label="Password"
          />
          <Field
            name="passwordConfirmation"
            component={renderInput}
            label="Password Confirmation"
          />
          <button className="ui button primary">Submit</button>
        </form>
      )}
    />
  );
};

export default SignUpForm;
