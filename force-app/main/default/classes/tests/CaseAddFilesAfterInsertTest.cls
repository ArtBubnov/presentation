@isTest
private class CaseAddFilesAfterInsertTest {

    @IsTest
    static void testAddFilesToCase() {
        List<Object> filesToInsert = new List<Object>();

        MultipleFileUploadController.FileInfo file = new MultipleFileUploadController.FileInfo();
        file.title = 'title';
        file.versionData = Blob.valueof('versionData');
        filesToInsert.add(file);
        MultipleFileUploadController.saveFiles(filesToInsert);

        List<ContentVersion> uploadedFiles = [
            SELECT Id, ContentDocumentId
            FROM ContentVersion
            WHERE Title = 'title'
            LIMIT 1
        ];

        List<Case> casesBefore = new List<Case>();
        Case urgentSpecialCase = new Case(
            Category__c = 'Pre Travel',
            Topic__c = 'Urgent special assistance',
            Initial_Reason_For_Contact__c = 'Info or Advice or Confirmation',
            Customer_Struggle__c = 'Need More Information',
            What_Is_The_Question__c = 'What Do You Offer?',
            Files_Ids_System__c = uploadedFiles[0].Id
        );
        casesBefore.add(urgentSpecialCase);

        Test.startTest();
        insert casesBefore;
        Test.stopTest();

        List<ContentDocumentLink> attachedFiles = [
            SELECT Id, ContentDocumentId, LinkedEntityId
            FROM ContentDocumentLink
            WHERE LinkedEntityId = :casesBefore[0].Id
                AND ContentDocumentId = :uploadedFiles[0].ContentDocumentId
        ];

        System.assertEquals(1, attachedFiles.size());
    }
}