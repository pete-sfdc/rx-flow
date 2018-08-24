@isTest private class EventTrigger_TEST  {
    @isTest static void simpleTest() {
        TestHelper th = new TestHelper('EventTrigger');
        th.createAdminUser();
        System.runAs(th.adminUser) {
            Test.startTest();
            th.createInsuredItem().createFormularyAssn().createMyRx().takePill();
            update th.pillTaken;
            test.stopTest();
        }
    }
}