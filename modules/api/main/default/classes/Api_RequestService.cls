public inherited sharing class Api_RequestService {

  public static final Api_RequestService INSTANCE = (Api_RequestService)fflibe_APP.SERVICE.newInstance(Api_RequestService.class);

  public String handleRequest(String handlerClassName, RestRequest req, RestResponse res) {
    try {
      Integer logLevel = Integer.valueOf(api_LogLevels__c.getInstance(UserInfo.getUserId()).LogLevel__c) ?? 1;

      api_IRequestHandler handler = (api_IRequestHandler)Type.forName(handlerClassName).newInstance();

      String handlerRes = handler.handleRequest(req, res);

      if (logLevel > 1) {
        // publish event to not accrue more dml
        api_LogEvent__e logEvent = new api_LogEvent__e(
          Body__c = req.requestBody.toString(),
          Method__c = req.httpMethod,
          Params__c = JSON.serialize(getRequestParams(req)),
          Message__c = 'SUCCESS',
          Type__c = 'DEBUG'
        );
        EventBus.publish(logEvent);
      }

      return handlerRes;

    } catch (Exception err) {
      // publish an event immediately so that we can log while still throwing the error
      api_LogEvent__e logEvent = new api_LogEvent__e(
        Body__c = req.requestBody.toString(),
        Method__c = req.httpMethod,
        Params__c = JSON.serialize(getRequestParams(req)),
        StackTrace__c = err.getStackTraceString(),
        Message__c = err.getMessage(),
        Type__c = 'ERROR'
      );
      EventBus.publish(logEvent);

      throw err;
    }
  }

  private Map<String, String> getRequestParams(RestRequest req) {
    Map<String,String> res = new Map<String, String>();
    for (String key : req.params.keySet()) {
      res.put(key, req.params.get(key));
    }
    return res;
  }

}