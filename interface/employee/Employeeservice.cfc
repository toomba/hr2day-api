component accessors="true" output="false"{

	property name="Employeeservice" inject="models.hr2day.app.employee.Employeeservice";

	public models.hr2day.interface.employee.Employeeservice function init() {
		return this;
	}

	public models.hr2day.domain.employee.Employee[] function findAll() {
		return employeeservice.findAll();
	}

	public models.hr2day.domain.employee.Employee[] function findAllActive() {
		return employeeservice.findAllActive();
	}

	public models.hr2day.domain.employee.Employee[] function findAllActiveWithLeave() {
		return employeeservice.findAllActiveWithLeave();
	}

	public models.hr2day.domain.employee.Employee[] function showComingLeave(
		required models.hr2day.domain.employee.Employee[] employees
	) {
		return employeeservice.showComingLeave(employees=employees);
	}

}