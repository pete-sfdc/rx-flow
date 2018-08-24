@IsTest(SeeAllData=true)
public class Test_EinsteinVision_Admin {
    
    @IsTest
    static void testIdPill()
    {
        Pill__C p = new Pill__C();
        insert p;
        
        Blob fileBlob = Blob.valueof('somedata');

        Test.StartTest();
        
        Test.setMock(HttpCalloutMock.class, new Test_EinsteinVision_HttpMockResponses());

        EinsteinVision_Admin.getPillPrediction('Beach and Mountain', p.Id, 'test_sample', fileBlob);
        
        Pill__c pill = [SELECT Id, Predicted_Drug_Name__c FROM Pill__C WHERE Id=:p.Id];
        
        System.assertEquals('beach', pill.Predicted_Drug_Name__c); //(expected, actual)
        
        Test.StopTest();
    }
    
    @IsTest
    static void testLabels()
    {
        Test.StartTest();

        Test.setMock(HttpCalloutMock.class, new Test_EinsteinVision_HttpMockResponses());
        
        List<EinsteinVision_Label> labels = EinsteinVision_Admin.getPillLabels('Beach and Mountain');
        
        System.assert(labels.size() > 0); //(expected, actual)

        List<EinsteinVision_Label> labels2 = EinsteinVision_Admin.getPillLabels('fail test');
        
        System.assert(labels2 == null); //(expected, actual)
        
        Test.StopTest();
    }
  
    @IsTest
	static void testImageUrlFromAttachment()
    { 
        Test.StartTest();
        
        Pill__C p = new Pill__C();
        insert p;
        
        Attachment attach = new Attachment();
        attach.Name = 'Unit Test Attachment';
        Blob bodyBlob = Blob.valueOf('Unit Test Attachment Body');
        attach.body = bodyBlob;
        attach.parentId = p.Id;
        attach.ContentType = 'application/msword';
        attach.IsPrivate = false;
        attach.Description = 'Test';
        insert attach;

		String attachId = EinsteinVision_Admin.getImageUrlFromAttachment(p.Id);
        
        System.assert(String.isNotBlank(attachId));

		attachId = EinsteinVision_Admin.getImageUrlFromAttachment(null);
        
        System.assert(String.isBlank(attachId));
        
        Test.StopTest();
    } 

}