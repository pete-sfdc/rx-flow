trigger PillTrigger on Pill__c (before insert, before update)  {
    if(Trigger.isBefore && Trigger.isInsert) {
        Pill_TH.beforeInsert(Trigger.new);
    }
    if(Trigger.isBefore && Trigger.isUpdate) {
        Pill_TH.beforeUpdate(Trigger.new, Trigger.oldMap);
    }
}