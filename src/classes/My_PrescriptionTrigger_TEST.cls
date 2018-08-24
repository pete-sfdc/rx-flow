@isTest private class My_PrescriptionTrigger_TEST  {
    @isTest static void simpleTest() {
        TestHelper th = new TestHelper('PrescriptionTrigger');
        th.createAdminUser();
        System.runAs(th.adminUser) {
            Test.startTest();
            th.createInsuredItem().createFormularyAssn().createMyRx().takePill();
            update th.pillTaken;
            test.stopTest();
        }
    }
}