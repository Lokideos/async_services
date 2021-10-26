# Project Documentation

This folder contains all information about the project documentation.

## Documentation

Below is the project documentation list:
* Initial project documentation
* Commands, Read Models, and Business Chains
* Business Chains diagram
* Data Model diagram
* Domain Model diagram
* BE and CUD events' producers and consumers

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

