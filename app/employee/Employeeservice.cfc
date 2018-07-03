component accessors="true" output="false"{

	property name="EmployeeRepository" inject="EmployeeRepository";
	property name="LeaveRepository" inject="LeaveRepository";
	property name="SickleaveRepository" inject="SickleaveRepository";

	public EmployeeService function init() {
		return this;
	}

	public models.hr2day.domain.employee.Employee[] function findAll() {
		return employeeRepository.findAll();
	}

	public models.hr2day.domain.employee.Employee[] function findAllActive() {
		return employeeRepository.findAllActive();
	}

	public models.hr2day.domain.employee.Employee[] function findAllActiveWithLeave() {
		var employees =  employeeRepository.findAllActive();
		var leaves =  leaveRepository.findFuture();
		var sickleaves =  sickleaveRepository.findFuture();

		loadLeaveForEmployee(employees,leaves);
		loadSickLeaveForEmployee(employees,sickleaves);

		return employees;
	}

	public models.hr2day.domain.employee.Employee[] function showComingLeave(
		required models.hr2day.domain.employee.Employee[] employees
	) {

		var leaves = [];

		for (var i=1;i<=arrayLen(employees);i++) {
			if (employees[i].hasLeave()) {
				arrayAppend(leaves, employees[i]);
			}
		}

		return leaves;
	}


	//---//

	private void function loadLeaveForEmployee(
		required models.hr2day.domain.employee.Employee[] employees,
		required models.hr2day.domain.leave.Leave[] leaves
	) {
		for (var e=1;e<=arrayLen(employees);e++) {
			for (var i=1;i<=arrayLen(leaves);i++) {
				if (leaves[i].getEmployeeID() == employees[e].getID()) {
					employees[e].addLeave(leaves[i]);
				}
			}
		}
	}

	private void function loadSickLeaveForEmployee(
		required models.hr2day.domain.employee.Employee[] employees,
		required models.hr2day.domain.sickleave.Sickleave[] sickleaves
	) {
		for (var e=1;e<=arrayLen(employees);e++) {
			for (var i=1;i<=arrayLen(sickleaves);i++) {
				if (sickleaves[i].getEmployeeID() == employees[e].getID()) {
					employees[e].addSickleave(sickleaves[i]);
				}
			}
		}
	}

}