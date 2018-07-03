component accessors="true" output="false" {

	property string id;
	property string firstname;
	property string initials;
	property string surname;
	property date hireDate;
	property date terminationDate;
	property numeric fulltimepercentage;
	property models.hr2day.domain.leave.Leave[] leave;
	property models.hr2day.domain.sickleave.Sickleave sickleave;

	public models.hr2day.domain.employee.Employee function init(
		required string id,
		required string surname,
		required date hireDate,
		numeric fulltimepercentage,
		string firstname,
		string initials,
		date terminationDate
	) {
		variables.id = id;
		variables.surname = surname;
		variables.hireDate = hireDate;
		variables.leave = [];
		variables.sickleave = [];
		if (structKeyExists(arguments, 'fulltimepercentage')) {
			variables.fulltimepercentage = fulltimepercentage;
		}
		if (structKeyExists(arguments, 'terminationDate')) {
			variables.terminationDate = terminationDate;
		}
		if (structKeyExists(arguments, 'firstname')) {
			variables.firstname = firstname;
		} else {
			variables.firstname = '';
		}
		if (structKeyExists(arguments, 'initials')) {
			variables.initials = initials;
		} else {
			variables.initials = '';
		}
		return this;
	}

	public boolean function hasLeave() {
		return arrayLen(variables.leave) GTE 1;
	};

	public numeric function getLeaveHours() {

		var leave = 0;

		if (hasLeave()) {

			for (var i=1;i<=arrayLen(getLeave());i++){
				leave = leave + getLeave()[i].getHours();
			}

		}

		return leave;
	}

	public void function addLeave(required models.hr2day.domain.leave.Leave leave) {
		arrayAppend(variables.leave, leave);
	};

	public boolean function hasSickleave() {
		return arrayLen(variables.sickleave) GTE 1;
	};

	public void function addSickleave(required models.hr2day.domain.sickleave.Sickleave sickleave) {
		arrayAppend(variables.sickleave, sickleave);
	};

	public boolean function hasTerminationDate() {
		return structKeyExists(variables, 'terminationDate') && isDate(variables.terminationDate) && dateCompare(now(), variables.terminationDate) >= 0;
	}

	public string function getFullName() {
		return variables.firstname & ' ' & variables.surname;
	}

}