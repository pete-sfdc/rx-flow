@isTest private class TestHelper_TEST  {

    @isTest static void testThis() {
        TestHelper th = new TestHelper('TestHelper');
        th.createAdminUser();
        System.runAs(th.adminUser) {
            Test.startTest();
            th.createInsuredItem().createMyFormulary().createFormularyAssn().createMyRx();
            test.stopTest();
        }
    }
}