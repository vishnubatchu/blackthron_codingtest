public with sharing class NonProfitController {
  @AuraEnabled(cacheable = true)
    public static string getNonProfits() {
      Http http = new Http();
      HttpRequest request = new HttpRequest();
      request.setEndpoint('https://apidata.guidestar.org/essentials/v2');
      request.setMethod('POST');
      request.setHeader('Subscription-Key', '407813e975774d7f92a2252d3509b977');
      request.setHeader('Content-Type', 'application/json;charset=UTF-8');
      request.setBody('{"search_terms": "Red"}');
      HttpResponse response = http.send(request);
  
      return response.getBody();
    }
}