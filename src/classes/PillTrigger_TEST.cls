@isTest private class PillTrigger_TEST  {

    @isTest static void simpleTest() {
        TestHelper th = new TestHelper('PillTrigger');
        th.createAdminUser();
        System.runAs(th.adminUser) {
            Test.startTest();
            th.createInsuredItem().createFormularyAssn().createMyRx().createPill();
            th.pill.Predicted_Drug_Name__c = 'Ethinylestradiol';
            update th.pill;
            th.pill.Predicted_Drug_Name__c = 'Lorazepam';
            update th.pill;
            test.stopTest();
        }
    }
}