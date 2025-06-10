// // import { LightningElement, api, track } from 'lwc';
// // import updateIndividualOptOutStatusByUniqueId from '@salesforce/apex/IndividualConsentManager.updateIndividualOptOutStatusByUniqueId';

// // export default class ConsentManagement extends LightningElement {    
// //     @track message = '';

// //     updateConsentStatus() {
// //         // Retrieve the unique_id from the URL
// //         //let uniqueId = new URL(window.location.href).searchParams.get('unique_id');
// //         let uniqueId = decodeURIComponent(new URL(window.location.href).searchParams.get('unique_id'));

// //         console.log("uniqueId received");
// //         console.log(uniqueId);

// //         if (!uniqueId) {
// //             //this.message = 'Unique ID not found in the URL.';
// //             console.log("uniqueId");
// //             console.log(uniqueId);
// //             let params = new URLSearchParams(window.location.search);
// // let uniqueString = params.get('unique_id');

// //             return;
// //         }

// //         // Call the Apex method to update the consent status
// //         updateIndividualOptOutStatusByUniqueId({ uniqueId: uniqueId, hasOptedOut: true }) // Assuming a true value for hasOptedOut for now. Adjust as needed.
// //             .then(result => {
// //                 this.message = result;
// //             })
// //             .catch(error => {
// //                 this.message = 'Error processing the Unique ID: ' + error.body.message;
// //             });
// //     }
// // }


// import { LightningElement, api, track } from 'lwc';
// import updateIndividualOptOutStatusByUniqueId from '@salesforce/apex/IndividualConsentManager.updateIndividualOptOutStatusByUniqueId';

// export default class ConsentManagement extends LightningElement {
//     @track message = '';

//     updateConsentStatus() {
//         // Get the current URL
//         const currentUrl = window.location.href;
//         console.log("currentUrl");
//         console.log(currentUrl);

//         // Extract the unique_id from the URL using regular expressions
//         const regex = /[?&]unique_id(=([^&#]*)|&|#|$)/;
//         const match = regex.exec(currentUrl);
//         console.log("match");
//         console.log(match); 

//         if (match && match[2]) {
//             const uniqueId = decodeURIComponent(match[2]);
//             console.log("uniqueId received");
//             console.log(uniqueId);

//             // Call the Apex method to update the consent status
//             updateIndividualOptOutStatusByUniqueId({ uniqueId: uniqueId, hasOptedOut: true }) // Adjust as needed.
//                 .then(result => {
//                     this.message = result;
//                 })
//                 .catch(error => {
//                     this.message = 'Error processing the Unique ID: ' + error.body.message;
//                 });
//         } else {
//             this.message = 'Unique ID not found in the URL.';
//         }
//     }
// }

// import { LightningElement, track } from 'lwc';
// // import updateIndividualOptOutStatusByUniqueId from '@salesforce/apex/IndividualConsentManager.updateIndividualOptOutStatusByUniqueId';

// export default class ConsentManagement extends LightningElement {
    
//     @track message = '';

//     connectedCallback() {
//         super.connectedCallback();

//         // Get the current URL
//         const currentUrl = window.location.href;
//         console.log("currentUrl");
//         console.log(currentUrl);

//         // Extract the unique_id from the URL using regular expressions
//         const regex = /[?&]unique_id(=([^&#]*)|&|#|$)/;
//         const match = regex.exec(currentUrl);
//         console.log("match");
//         console.log(match);

//         if (match && match[2]) {
//             const uniqueId = decodeURIComponent(match[2]);
//             console.log("uniqueId received");
//             console.log(uniqueId);

//             // Call the Apex method to update the consent status
//             updateIndividualOptOutStatusByUniqueId({ uniqueId: uniqueId, hasOptedOut: true }) // Adjust as needed.
//                 .then(result => {
//                     this.message = result;
//                 })
//                 .catch(error => {
//                     this.message = 'Error processing the Unique ID: ' + error.body.message;
//                 });
//         } else {
//             this.message = 'Unique ID not found in the URL.';
//         }
//     }
// }

// import { LightningElement, track } from 'lwc';
// import updateIndividualOptOutStatusByUniqueId from '@salesforce/apex/IndividualConsentManager.updateIndividualOptOutStatusByUniqueId';

// export default class ConsentManagement extends LightningElement {
//     @track message = '';

//     updateConsentStatus() {
//         // Get the current URL
//         const currentUrl = window.location.href;
//         console.log("currentUrl");
//         console.log(currentUrl);

//         // Extract the unique_id from the URL using regular expressions
//         const regex = /[?&]unique_id(=([^&#]*)|&|#|$)/;
//         const match = regex.exec(currentUrl);
//         console.log("match");
//         console.log(match);

//         if (match && match[2]) {
//             const uniqueId = decodeURIComponent(match[2]);
//             console.log("uniqueId received");
//             console.log(uniqueId);

//             // Call the Apex method to update the consent status
//             updateIndividualOptOutStatusByUniqueId({ uniqueId: uniqueId, hasOptedOut: true }) // Adjust as needed.
//                 .then(result => {
//                     this.message = result;
//                 })
//                 .catch(error => {
//                     this.message = 'Error processing the Unique ID: ' + error.body.message;
//                 });
//         } else {
//             this.message = 'Unique ID not found in the URL.';
//         }
//     }
// }

import { LightningElement, track, wire } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import updateIndividualOptOutStatusByUniqueId from '@salesforce/apex/IndividualConsentManager.updateIndividualOptOutStatusByUniqueId';

export default class ConsentManagement extends LightningElement {
    @track message = '';
    pageReference = {};

    @wire(CurrentPageReference)
    setCurrentPageReference(currentPageReference) {
        this.pageReference = currentPageReference;
    }

    updateConsentStatus() {
        if (this.pageReference && this.pageReference.state) {
            const uniqueId = this.pageReference.state.unique_id;
            
            if (uniqueId) {
                console.log("uniqueId received");
                console.log(uniqueId);

                // Call the Apex method to update the consent status
                updateIndividualOptOutStatusByUniqueId({ uniqueId: uniqueId, hasOptedOut: true }) // Adjust as needed.
                    .then(result => {
                        this.message = result;
                    })
                    .catch(error => {
                        this.message = 'Error processing the Unique ID: ' + error.body.message;
                    });
            } else {
                this.message = 'Unique ID not found in the URL.';
            }
        } else {
            this.message = 'Failed to retrieve current page reference.';
        }
    }
}