component accessors="true" output="false" singleton{

	property name="SalesforceRepository" inject="SalesforceRepository";
	property name="settings" inject="coldbox:setting:hr2day";

	public models.hr2day.infrastructure.employee.EmployeeRepository function init() {
		return this;
	}

	public models.hr2day.domain.employee.Employee[] function findAll() {

		var rawjson = salesforceRepository.makeCall(url=settings.employeeUrl);
		var json = deserializeJSON(rawjson.filecontent);
		var employees = [];

		for (var i=1;i<=arrayLen(json);i++) {
			var employee = new models.hr2day.domain.employee.Employee(
							id = json[i].id,
							surname = json[i].hr2d__Surname__c,
							hireDate = json[i].hr2d__HireDateConcern__c
			);

			if (structKeyExists(json[i], 'hr2d__FirstName__c')) {
				employee.setFirstname(json[i].hr2d__FirstName__c)
			}
			if (structKeyExists(json[i], 'hr2d__WtfTotalToday__c')) {
				employee.setFulltimepercentage(json[i].hr2d__WtfTotalToday__c)
			}
			if (structKeyExists(json[i], 'hr2d__TerminationDate__c')) {
				employee.setTerminationDate(json[i].hr2d__TerminationDate__c)
			}
			if (structKeyExists(json[i], 'hr2d__Initials__c')) {
				employee.setInitials(json[i].hr2d__Initials__c)
			}
			arrayAppend(employees, employee);

		}

		arraySort(employees, function (current_element, next_element) {
			return comparenocase(current_element.getSurname(), next_element.getSurname());
		});

		return employees;
	}

	public models.hr2day.domain.employee.Employee[] function findAllActive() {
		var allEmployees = findAll();
		var employees = [];
		for(var i=1;i<=arrayLen(allEmployees);i++) {
			if (!allEmployees[i].hasTerminationDate()) {
				arrayAppend(employees, allEmployees[i]);
			}
		}
		return employees;
	}

}