import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getSBA_BatchJobNames from '@salesforce/apex/SBA_BatchJobController.getSBA_BatchJobNames';
import runSBA_BatchJob from '@salesforce/apex/SBA_BatchJobController.runSBA_BatchJob';

export default class SbaBatchJobRunner extends LightningElement {
    @track value = '';
    @track options = [];
    @track jobTriggered = false; // new property to track if job is triggered

    connectedCallback() {
        this.loadSBA_BatchJobs();
    }

    loadSBA_BatchJobs() {
        getSBA_BatchJobNames()
        .then(result => {
            let batchJobs = [];
            result.forEach(element => {
                batchJobs.push({label: element, value: element});
            });
            this.options = batchJobs;
        })
        .catch(error => {
            console.error('Error loading batch jobs', error);
        });
    }

    handleChange(event) {
        this.value = event.detail.value;
    }

    handleRun() {
        runSBA_BatchJob({jobName: this.value})
        .then(() => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Batch job triggered successfully.',
                    variant: 'success',
                }),
            );
            this.jobTriggered = true;
        })
        .catch(error => {
            console.error('Error triggering batch job', error);
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error triggering batch job',
                    message: error.body.message,
                    variant: 'error',
                }),
            );
        });
    }
}