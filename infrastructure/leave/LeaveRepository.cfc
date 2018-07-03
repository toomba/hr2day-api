component accessors="true" output="false"{

	property name="SalesforceRepository" inject="SalesforceRepository";
	property name="settings" inject="coldbox:setting:hr2day";

	public models.hr2day.infrastructure.leave.LeaveRepository function init() {
		return this;
	}

	public models.hr2day.domain.leave.Leave[] function findFuture() {

		var rawjson = salesforceRepository.makeCall(url=settings.leaveUrl);
		var json = deserializeJSON(rawjson.filecontent);
		var leaves = [];

		for (var i=1;i<=arrayLen(json);i++) {

			var leave = new models.hr2day.domain.leave.Leave();
			if (structKeyExists(json[i], 'hr2d__StartDate__c')) {
				leave.setStartDate(json[i].hr2d__StartDate__c);
			}
			if (structKeyExists(json[i], 'hr2d__EndDate__c')) {
				leave.setEndDate(json[i].hr2d__EndDate__c);
			}
			if (structKeyExists(json[i], 'hr2d__Hours__c')) {
				leave.setHours(json[i].hr2d__Hours__c);
			}
			if (structKeyExists(json[i], 'hr2d__Description__c')) {
				leave.setDescription(json[i].hr2d__Description__c);
			}
			if (structKeyExists(json[i], 'hr2d__Workflowstatus__c')) {
				leave.setStatus(json[i].hr2d__Workflowstatus__c);
			}
			if (structKeyExists(json[i], 'hr2d__Employee__r') && structKeyExists(json[i].hr2d__Employee__r, 'id') ) {
				leave.setEmployeeID(json[i].hr2d__Employee__r.id);
			}
			arrayAppend(leaves, leave);
		}

		arraySort(leaves, function (current_element, next_element) {
			return comparenocase(current_element.getStartDate(), next_element.getStartDate());
		});

		return leaves;

	}

}