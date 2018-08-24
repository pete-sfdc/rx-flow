// My Prescription (My_Prescription__c) trigger handler
public with sharing class My_Prescription_TH  {

    public static void beforeUpdate(Map<Id,My_Prescription__c> triggerNewMap) {

        // keep stuff clean
        Id whatId;
        Decimal count;

        // rolls up pills taken
        // Aggregates are efficient
        for(AggregateResult ev:[
            SELECT  WhatId, SUM(Pill_Number__c)
            FROM    Event
            WHERE   WhatId IN:triggerNewMap.keySet()
            GROUP BY WhatId
        ]) {
            // easier to read
            whatId = (Id)ev.get('WhatId');
            count = (Decimal)ev.get('expr0');
            // apply changes
            triggerNewMap.get(whatId).Pills_Taken__c = count;
        }
    }
}