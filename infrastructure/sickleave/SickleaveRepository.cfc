component accessors="true" output="false"{

	property name="SalesforceRepository" inject="SalesforceRepository";
	property name="settings" inject="coldbox:setting:hr2day";

	public models.hr2day.infrastructure.sickleave.SickleaveRepository function init(
	) {
		return this;
	}

	public models.hr2day.domain.sickleave.Sickleave[] function findFuture() {

		var rawjson = salesforceRepository.makeCall(url=settings.sickleaveUrl);
		var json = deserializeJSON(rawjson.filecontent);
		var sickleaves = [];

		for (var i=1;i<=arrayLen(json);i++) {

			if (structKeyExists(json[i], 'IsDeleted') && json[i].IsDeleted == false) {

				var sickleave = new models.hr2day.domain.sickleave.Sickleave();
				if (structKeyExists(json[i], 'hr2d__StartDate__c')) {
					sickleave.setStartDate(json[i].hr2d__StartDate__c);
				}
				if (structKeyExists(json[i], 'hr2d__EndDate__c')) {
					sickleave.setEndDate(json[i].hr2d__EndDate__c);
				}
				if (structKeyExists(json[i], 'hr2d__ClassificationPicked__c')) {
					sickleave.setDescription(json[i].hr2d__ClassificationPicked__c);
				}
				if (structKeyExists(json[i], 'hr2d__Employee__r') && structKeyExists(json[i].hr2d__Employee__r, 'id') ) {
					sickleave.setEmployeeID(json[i].hr2d__Employee__r.id);
				}
				arrayAppend(sickleaves, sickleave);

			}

		}

		arraySort(sickleaves, function (current_element, next_element) {
			return comparenocase(current_element.getStartDate(), next_element.getStartDate());
		});

		return sickleaves;

	}

}