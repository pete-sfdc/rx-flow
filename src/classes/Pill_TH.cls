// Pill Identifier (Pill__c) trigger handler
public with sharing class Pill_TH  {

    public static void beforeInsert(List<Pill__c> newTrigger) {
        doPrescriptionLookup(newTrigger);
    }

    public static void beforeUpdate(List<Pill__c> newTrigger, Map<Id, Pill__c> oldTrigger) {
        // the logic only needs to runs if something important has changed
        List<Pill__c> changedPills = new List<Pill__c>();

        // loop through trigger items
        for(Pill__c pill:newTrigger) {
            // if something important has changed
            if(pill.Predicted_Drug_Name__c != oldTrigger.get(pill.Id).Predicted_Drug_Name__c || pill.OwnerId != oldTrigger.get(pill.Id).OwnerId) {
                // add the pill to the list
                changedPills.add(pill);
            }
        }

        // if there are pills in the list
        if(changedPills != null && !changedPills.isEmpty()) {
            // do the prescription look up on the list
            doPrescriptionLookup(changedPills);
        }
    }

    public static void doPrescriptionLookup(List<Pill__c> pills) {

        // using this kind of map means you only have to use two loops
        // the key matches the Finding_Prescription_Filter__c formula field
        Map<String,List<Pill__c>> pillMap = new Map<String,List<Pill__c>>();

        // makes the code run faster with less memory
        String key;

        // build the pill map
        for(Pill__c pill:pills) {

            // build the key
            key = pill.OwnerId;
            if (String.isNotBlank(pill.Predicted_Drug_Name__c))
            {
                key = key + pill.Predicted_Drug_Name__c.toLowerCase();
            }
            System.debug('Pill Key is ' + key);

            // if the key is in the map, add the pill to the list
            if(pillMap.containsKey(key)) pillMap.get(key).add(pill);
            else pillMap.put(key, new List<Pill__c>{pill});
        }

        // loop through the query results
        for(My_Prescription__c mp:[
            SELECT  Id, Finding_Prescription_Filter__c
            FROM    My_Prescription__c 
            WHERE   Finding_Prescription_Filter__c IN :pillMap.keySet()
            AND     Finding_Prescription_Filter__c != null
            AND     Finding_Prescription_Filter__c != ''
        ]) {
            key = mp.Finding_Prescription_Filter__c;
            // it should exist
            if(pillMap.containsKey(key)) {
                // loop through the pills under this key
                for(Pill__c pill:pillMap.get(key)) {
                    // assign the correct prescription ID
                    pill.My_Prescription__c = mp.Id;
                }
            }
        }
    }
}

/*
I was a working journalist, a hired geek of sorts, and Lazlo was great copy and 
sometimes a great lawyer. It was a fast, strange time and we worked in a fast, 
strange ways.
*/