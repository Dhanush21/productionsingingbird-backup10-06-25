import { LightningElement,api } from 'lwc';
import sendReminder from '@salesforce/apex/TwilioSMSService1.sendReminder';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class SendPaymentReminderButton extends LightningElement {
      @api recordId;

    handleClick() {
        sendReminder({ recordId: this.recordId })
            .then(() => {
                this.dispatchEvent(new ShowToastEvent({
                    title: 'Success',
                    message: 'SMS reminder sent!',
                    variant: 'success'
                }));
            })
            .catch(error => {
                this.dispatchEvent(new ShowToastEvent({
                    title: 'Error',
                    message: error.body?.message || 'SMS failed.',
                    variant: 'error'
                }));
            });
    }

}