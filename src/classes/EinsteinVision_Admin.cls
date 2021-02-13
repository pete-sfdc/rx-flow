public class EinsteinVision_Admin {
    
    @AuraEnabled
    public static void createDatasetFromUrl(String zipUrl) {
        EinsteinVision_PredictionService service = new EinsteinVision_PredictionService();
        service.createDatasetFromUrlAsync(zipUrl);
    }
    
    @AuraEnabled
    public static List<EinsteinVision_Dataset> getDatasets() {
        EinsteinVision_PredictionService service = new EinsteinVision_PredictionService();
        EinsteinVision_Dataset[] datasets = service.getDatasets();
        return datasets;
    }
    
    @AuraEnabled
    public static String trainDataset(Decimal datasetId) {
        EinsteinVision_PredictionService service = new EinsteinVision_PredictionService();
        EinsteinVision_Model model = service.trainDataset(Long.valueOf(String.valueOf(datasetId)), 'Training', 0, 0, '');
        return model.modelId;
    }
    
    @AuraEnabled
    public static void deleteDataset(Long datasetId) {
        EinsteinVision_PredictionService service = new EinsteinVision_PredictionService();
        service.deleteDataset(datasetId);
    }
    
    @AuraEnabled
    public static List<EinsteinVision_Model> getModels(Long datasetId) {
        EinsteinVision_PredictionService service = new EinsteinVision_PredictionService();
        EinsteinVision_Model[] models = service.getModels(datasetId);
        return models;
    }
    
    @AuraEnabled
    public static void getPillPrediction(Id pillId, String fileName, String base64) {
        Blob fileBlob = EncodingUtil.base64Decode(String.escapeSingleQuotes(base64));
        getPillPrediction('Pills', pillId, fileName, fileBlob);
    }
    @TestVisible
    private static void getPillPrediction(String datasetName, Id pillId, String fileName, Blob fileBlob)
    {
        String pillIdClean = String.escapeSingleQuotes(pillId);
        
        EinsteinVision_PredictionService service = new EinsteinVision_PredictionService();
        EinsteinVision_Dataset[] datasets = service.getDatasets();
        for (EinsteinVision_Dataset dataset : datasets) {
            if (dataset.Name.equals(datasetName)) {
                EinsteinVision_Model[] models = service.getModels(dataset.id);
                EinsteinVision_Model model = models.get(0);
                EinsteinVision_PredictionResult result = service.predictBlob(model, fileBlob, '');
                EinsteinVision_Probability probability = result.probabilities.get(0);
                
                if (Schema.SObjectType.Pill__c.isAccessible()
                   && Schema.SObjectType.Attachment.isAccessible())
                {
                    Pill__c pill = [SELECT Id FROM Pill__C WHERE Id=:pillIdClean];
                    if (Schema.SObjectType.Pill__c.fields.Predicted_Drug_Name__c.isUpdateable())
                    {
                        pill.Predicted_Drug_Name__c = probability.label;
                        update pill;
                    }
                    if (Schema.SObjectType.Attachment.isDeletable()
                        && Schema.SObjectType.Attachment.isCreateable()
                       	&& Schema.SObjectType.Attachment.fields.Body.isUpdateable()
                       	&& Schema.SObjectType.Attachment.fields.ParentId.isUpdateable()
                       	&& Schema.SObjectType.Attachment.fields.Name.isUpdateable())
                    {
                        Attachment[] attsOld = [SELECT Id FROM Attachment WHERE ParentId=:pillIdClean];
                        delete attsOld;
                        Attachment att = new Attachment();
                        att.Body = fileBlob;
                        att.ParentId = String.escapeSingleQuotes(pill.Id);
                        att.Name = String.escapeSingleQuotes(fileName);
                        insert att;
                    }
                }
            }
        }
    }
    
    @AuraEnabled
    public static List<EinsteinVision_Label> getPillLabels()
    {
        return getPillLabels('Pills');
    }
    @TestVisible
    private static List<EinsteinVision_Label> getPillLabels(String datasetName)
    {
        EinsteinVision_PredictionService service = new EinsteinVision_PredictionService();
        EinsteinVision_Dataset[] datasets = service.getDatasets();
        for (EinsteinVision_Dataset dataset : datasets) {
            if (dataset.Name.equals(datasetName)) {
                return dataset.labelSummary.labels;
            }
        }
        return null;
    }
    
    @AuraEnabled
    public static String getImageUrlFromAttachment(Id pillId) {
        List<Attachment> atts = [SELECT Id FROM Attachment WHERE ParentId=:pillId];
        if (atts.size()>0) {
            return atts.get(0).Id;
        }
        return '';
    }
    
}
