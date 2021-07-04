@isTest
public class ResponseNonProfit implements HttpCalloutMock {

  public HTTPResponse respond(HTTPRequest req) {

    System.assertEquals('https://apidata.guidestar.org/essentials/v2', req.getEndpoint());
    System.assertEquals('POST', req.getMethod());

    HttpResponse res = new HttpResponse();
    res.setHeader('Content-Type', 'application/json');
    res.setBody('{"example":"test"}');
    res.setStatusCode(200);
    return res;
  }

}