// Event trigger handler
public with sharing class Event_TH  {

    public static void afterInsert(List<Event> newTrigger) {
        doRollups(newTrigger);
    }

    public static void afterUpdate(List<Event> newTrigger) {
        doRollups(newTrigger);
    }

    public static void doRollups(List<Event> newTrigger) {
        // lay the groundwork
        Set<Id> rxIDs = new Set<Id>();

        // pull sObject type for My_Prescription__c
        SObjectType rxSObjectType = My_Prescription__c.getSObjectType();

        // loop through events
        for(Event ev:newTrigger) {
            // if they are related to My_Prescription__c records
            if(String.isNotBlank(ev.WhatId) && ev.WhatId.getSObjectType() == rxSObjectType) {
                // add to the rxIDs
                rxIDs.add(ev.WhatId);
            }
        }

        // if there are IDs
        if(rxIDs != null && !rxIDs.isEmpty()) {
            // you'll need this in a second
            List<My_Prescription__c> rxToUpdate = new List<My_Prescription__c>();

            // loop through them
            for(String rxID:rxIDs) {
                // add shell My_Prescription__c records
                rxToUpdate.add(new My_Prescription__c(Id = rxID));
            }

            // update the shell records
            update rxToUpdate;
        }
    }
}