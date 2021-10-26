# Project Documentation

This folder contains all information about the project documentation.

## Documentation

Below is the project documentation list:
* [Initial project documentation](initial/README.md)
* [Commands, Read Models, and Business Chains](business_requirements/README.md)
* [Business Chains diagram](business_requirements/business_chains_diagrams.jpeg)
* [Data Model diagram](data_model.jpeg)
* [Domain Model diagram](domain_model.jpeg)
* [BE and CUD events' producers and consumers](events/README.md)

## Services

Based on the design, there will be four services in total:
* **Auth** service will be responsible for handling authentication.
* **Tasks** service will handle the main task tracker functionality - tasks dashboard.
* The **accounting** service will assign a cost to tasks, change account balance, billing periods, and balance dashboards for developers and management.
* **Analytics** service will show balance status for daily profit and tasks cost analytics.

## Communications

* Almost all communications in the Task Tracker system will be asynchronous.
* One exception will be part of the authentication flow.
  * The main authentication flow will be synchronous, but it will also produce CUD events 
  to keep user data up to date across services. So, it will be mixed (sync/async) interaction.

