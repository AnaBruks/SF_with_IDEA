/**
 * Created by anast on 24.10.2022.
 */
import { LightningElement, wire, api, track } from 'lwc';
import retrieveDeals from '@salesforce/apex/FetchRelatedDeals.retrieveDeals';
import makePostCallout from '@salesforce/apex/SalesManagerCallouts.makePostCallout';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

const COLUMNS = [
                        { label: 'Name', fieldName: 'Name' },
                        { label: 'Start Date', fieldName: 'Start_Date__c' },
                        { label: 'Status', fieldName: 'Status__c'}
];

export default class RelatedListComponent extends LightningElement {
    @api recordId;
    records;
    columns = COLUMNS;

   @wire(retrieveDeals, { recordId: '$recordId' } )listInfo( { error, data } ) {
        if ( data ) {
            this.records = data;
            this.error = undefined;
            console.log( 'Records are ' + JSON.stringify( this.records ) );
        } else if (error) {
            this.records = undefined;
            }
       }

    showText = false;
    textValue = 'Manager is Synchronized!';

    handleClick(event) {
        makePostCallout({recordId: this.recordId}).then(result => {
                if (result===true) {
                    this.showText = true ;
                    this.showPosNotification();
                    setTimeout(() => {window.location.reload(true)}, 2000);
                } else {
                    this.showNegNotification();
                }
               })
               .catch(error => {
                   console.error('Error:', error)
               });
    }

    showPosNotification() {
        const evt = new ShowToastEvent({
            title: 'You\'re just synced this sales manager.',
            message: 'Syncronized!',
            variant: 'success',
        });
        this.dispatchEvent(evt);
    }

    showNegNotification(){
        const eve = new ShowToastEvent({
            title: 'Can\'t sync this sales manager.',
            message: 'Error!',
            variant: 'warning',
        });
        this.dispatchEvent(eve);
    }
}



