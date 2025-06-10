import { LightningElement, api } from 'lwc';

export default class RecordFileUploader extends LightningElement {
    @api recordId; // The ID of the record to attach the file to

    // Accepted file formats
    get acceptedFormats() {
        return ['.png', '.jpg', '.jpeg'];
    }

    // Handler for when a file is uploaded
    handleUploadFinished(event) {
        // Get the list of uploaded files
        const uploadedFiles = event.detail.files;
        alert("No. of files uploaded : " + uploadedFiles.length);
    }
}