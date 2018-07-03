# hr2day API

With this module you will be able to access and manage your [hr2day] account via API. It implements the most of the functionalities of the API.

## Installation

Via CommandBox, by executing the next line (with parameters if needed):

```box install hr2day-api```

Via `box.json`, just add the correspondent lines:
```
    "devDependencies":{
        "hr2day-api":"1.0.0"
    },
    "installPaths":{
        "hr2day-api":"models/hr2day-api"
    },
    "dependencies":{
        "hr2day-api":"^1.0.0"
    }
```

## Credentials

You need to place your credentials in your `Coldbox.cfc` file like this:

```
hr2day = {
    employeeUrl = "/services/apexrest/hr2d/employee?wg=##COMPANY##",
    sickleaveUrl = "/services/apexrest/hr2d/SickLeave?wg=##COMPANY##&dateFrom=#year(now())#0101",
    leaveUrl = "/services/apexrest/hr2d/Leave?wg=##COMPANY##&dateFrom=#year(now())#0101",
    url="https://login.salesforce.com/services/oauth2/token",
    client_id="##CLIENT_ID##",
    client_secret="##CLIENT_SECRET##",
    username="##USERNAME##",
    password="##PASSWORD##"
}
```

## Retrieve objects

Once it's configured you can access everything in your hr2day account in this way:

```property name="EmployeeService" inject="EmployeeService";``` Inject the service first
```prc.employees = EmployeeService.findAllActiveWithLeave();``` Example of a call to a service

etc.

   [hr2day]: <https://www.hr2day.com//>
