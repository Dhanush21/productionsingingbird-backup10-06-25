// accountDashboard.js
import { LightningElement, api, wire, track } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import getOpenOpportunities from '@salesforce/apex/AccountController.getOpenOpportunities';

const fields = ['Account.Name'];

export default class AccountDashboard extends LightningElement {
    @api recordId;

    @wire(getRecord, { recordId: '$recordId', fields })
    account;

    @track contacts; // Use @track to monitor changes in the contacts data

    get accountName() {
        return this.account && this.account.data
            ? getFieldValue(this.account.data, 'Account.Name')
            : '';
    }

    // Fetch open opportunities
    @wire(getOpenOpportunities, { accountId: '$recordId' })
    wiredOpportunities({ error, data }) {
        if (data) {
            this.contacts = data;
        } else if (error) {
            // Handle the error appropriately
            this.contacts = null;
        }
    }

    // Define the columns for the lightning-datatable
    columns = [
        { label: 'Name', fieldName: 'Name', type: 'text' },
        { label: 'Title', fieldName: 'Title', type: 'text' },
        { label: 'Email', fieldName: 'Email', type: 'email' },
        { label: 'Phone', fieldName: 'Phone', type: 'phone' }
    ];
}