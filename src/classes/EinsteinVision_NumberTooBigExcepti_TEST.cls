@isTest private class EinsteinVision_NumberTooBigExcepti_TEST  {

    @isTest static void simpleTest() {
        TestHelper th = new TestHelper('EinsteinVisionTrigger');
        th.createAdminUser();
        System.runAs(th.adminUser) {
            Test.startTest();
            try {
                throw new EinsteinVision_NumberTooBigException ('wherrrrrr?', 9000, 9001);
            } catch(Exception e) {
                System.debug('It\'s over 9,000!!!');
            }
            try {
                throw new EinsteinVision_NumberTooBigException ('what?', 9000.0, 9001.0);
            } catch(Exception e) {
                System.debug('It\'s over 9,000.0!!!');
            }
            Test.stopTest();
        }
    }
}