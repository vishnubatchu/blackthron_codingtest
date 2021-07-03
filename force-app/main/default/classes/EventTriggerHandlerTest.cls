@isTest
public class EventTriggerHandlerTest {
    
    @isTest
    public static void testBeforeInsert(){
        list<Max_Events_Per_User__mdt> lstMeta = [SELECT Max__c FROM Max_Events_Per_User__mdt];
        Decimal max;

        if(!lstMeta.isEmpty()) {     
            max = lstMeta[0].Max__c;

            try{
                List<Event> events = new List<Event>();
                for(integer i = 1; i <= max + 1; i++){
                    Event eventObj = new Event(
                                            Subject = 'Call', 
                                            StartDateTime = DateTime.now(), 
                                            EndDateTime = DateTime.now().addDays(1)
                                            );
                                            events.add(eventObj);
                }

                insert events;
            } catch (DmlException e) {
                System.assert(e.getDmlMessage(0).indexOf('Too many Events created this month for user') > -1);
            }                                                            
        }
    }  
}