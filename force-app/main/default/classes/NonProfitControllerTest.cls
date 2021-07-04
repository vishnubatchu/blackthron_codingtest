@isTest
private class NonProfitControllerTest {

  @isTest static void testGetCallout() {
    Test.setMock(HttpCalloutMock.class, new ResponseNonProfit());

    String response = NonProfitController.getNonProfits();
    System.debug(response);
    String actualValue = response;
    String expectedValue = '{"example":"test"}';
    System.assertEquals(actualValue, expectedValue);

  }
}