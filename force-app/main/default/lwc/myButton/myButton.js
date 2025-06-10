import { LightningElement } from 'lwc';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class MyLWC extends LightningElement {
    handleButtonClick() {
        this.callBatchApex();
    }

    callBatchApex() {
        let jobId = '';
        Apex.enqueueAction({
            "actions": [{ "className": "BatchJobCaller_1" }],
            "onSuccess": (response) => {
                jobId = response.returnValue;
                this.showToast('Batch Apex Job Started', 'success');
                refreshApex(); // Optional: Refresh any data in the component
            },
            "onError": (error) => {
                this.showToast('Error Starting Batch Apex Job', 'error');
                console.error(error);
            }
        });
    }

    showToast(title, variant) {
        const toastEvent = new ShowToastEvent({
            title: title,
            variant: variant
        });
        this.dispatchEvent(toastEvent);
    }
}