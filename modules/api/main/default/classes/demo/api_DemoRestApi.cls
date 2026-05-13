@RestResource(urlMapping='/demo')
global with sharing class api_DemoRestApi {
    

  @HttpPost
  global static String doPost() {
    RestRequest req = RestContext.request;
    RestResponse res = Restcontext.response;

    String postRes = Api_RequestService.INSTANCE.handleRequest('api_DemoPostHandler', req, res);

    return postRes;
  }
}