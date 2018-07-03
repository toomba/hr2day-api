component accessors="false" output="false" {

	property name="settings" inject="coldbox:setting:hr2day";
	property string token;
	property string instance_url;

	public models.hr2day.infrastructure.salesforce.SalesforceRepository function init() {
		return this;
	}

	public any function getApiToken(){
		if(isNull(variables.token)){
			local.http = new Http(url=settings.url,method="POST");
			http.addParam(type='formfield',name='grant_type',value='password');
			http.addParam(type='formfield',name='client_id',value=settings.client_id);
			http.addParam(type='formfield',name='client_secret',value=settings.client_secret);
			http.addParam(type='formfield',name='username',value=settings.username);
			http.addParam(type='formfield',name='password',value=settings.password);
			http.addParam(type='formfield',name='format',value='json');

			var httpSendResult = local.http.send().getPrefix();

			variables.token = deserializeJSON(httpSendResult.filecontent).access_token;
			variables.instance_url = deserializeJSON(httpSendResult.filecontent).instance_url;
		}

		return variables.token;
	}

	public any function getInstanceUrl(){
		if(isNull(variables.instance_url)){
			getApiToken();
		}

		return variables.instance_url;
	}



	public any function makeCall(required string url,  string method, struct params, any attempt = 0) {
		local.http = new Http(url="#getInstanceUrl()##arguments.url#",method="GET");
		local.http.addParam(type='header',name='Authorization',value='Bearer ' & getApiToken());
		local.httpSendResult = local.http.send().getPrefix();

		if (local.httpSendResult.responseHeader.status_code EQ 401) {
			if (NOT isdefined('arguments.attempt') or arguments.attempt EQ 0) {
				return makeCall(arguments.url,arguments.method,arguments.params,attempt + 1);
			} else {
				throw (message = 'Unable to log into SalesForce: ' & local.httpSendResult.responseHeader.status_code & '('&gatherResponseString(local.httpSendResult)&')',detail=gatherResponseString(local.httpSendResult),type='salesforce.loginFailure');
			}
		} else {
			return local.httpSendResult;
		}
	}

}