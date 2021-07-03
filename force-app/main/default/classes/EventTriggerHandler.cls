public class EventTriggerHandler {
    public static void beforeInsert(List<Event> newEvents){        
        validateMaxEvents(newEvents);
    }

    static void validateMaxEvents(List<Event> newEvents){
        Decimal max;    
        List<Max_Events_Per_User__mdt> meta;
        Map<String, Decimal> mapUserEvent = new Map<String, Decimal>();

        for(Max_Events_Per_User__mdt m : [SELECT User_Email__c, Max__c FROM Max_Events_Per_User__mdt]){
            mapUserEvent.put(m.User_Email__c, m.Max__c);
        }
        if(mapUserEvent.values().isEmpty()) return; 

        Integer month = Date.Today().Month();
        Integer year = Date.Today().Year();

        integer eventCountPerUser = 0;
        list<AggregateResult> existingEventGroups = [SELECT OwnerId, COUNT(Id)eventCount 
                                                    FROM Event                                                     
                                                    WHERE CALENDAR_YEAR(CreatedDate) =: year AND CALENDAR_MONTH(CreatedDate) =: month
                                                    GROUP BY OwnerId ]; // add month and year filter here.
        
        for(AggregateResult agr : existingEventGroups){
            eventCountPerUser = (Integer)agr.get('eventCount');            
        }            

        //group events created per user
        for(Event e : newEvents){
            eventCountPerUser++; //keep this incrementing for the num of new events
            for(String email : mapUserEvent.keySet()){      //check the max limit for each user/email          
                Decimal maxPerUser = mapUserEvent.get(email);

                if(maxPerUser < eventCountPerUser){
                    string errorMsg = String.format('Too many Events created this month for user {0}: {1}', 
                                                    new List<String>{String.valueOf(e.OwnerId), String.valueOf(maxPerUser)});
                    e.addError(errorMsg);
                }   
            }                   
        }
    }
}