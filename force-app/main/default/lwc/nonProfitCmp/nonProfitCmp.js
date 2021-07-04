import {LightningElement,wire,api,track} from 'lwc';
import getNonProfits from '@salesforce/apex/NonProfitController.getNonProfits';
import {createRecord} from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import CNAME_FIELD from '@salesforce/schema/Non_Profit__c.contactname__c';
import CEMAIL_FIELD from '@salesforce/schema/Non_Profit__c.contactemail__c';
import CPHONE_FIELD from '@salesforce/schema/Non_Profit__c.contactphone__c';
import NON_PROFIT_OBJECT from '@salesforce/schema/Non_Profit__c';
import NAME_FIELD from '@salesforce/schema/Non_Profit__c.Name';
import ACC_FIELD from '@salesforce/schema/Non_Profit__c.Account__c';

export default class NonProfitCmp extends LightningElement {
    @api recordId;
    @track nonProfits = [];
    error;
	
  //fetching all non profit org data

    @wire(getNonProfits)
	opps({
		error,
		data
	}) {
		if(data) {
			let prsed = JSON.parse(data);
			this.nonProfits = prsed.data.hits;
		} else {

			this.error = error;
		}
	}

	// here we are handling click on create button, placed against name on UI, it will related Non profit record.
    handleClick(event) {		
		const fields = {};

		fields[NAME_FIELD.fieldApiName] = this.nonProfits[event.target.id.split('-')[0]].organization_name;
		fields[ACC_FIELD.fieldApiName] = this.recordId;
		fields[CPHONE_FIELD.fieldApiName] = this.nonProfits[event.target.id.split('-')[0]].contact_phone;
        fields[CEMAIL_FIELD.fieldApiName] = this.nonProfits[event.target.id.split('-')[0]].contact_email;
        fields[CNAME_FIELD.fieldApiName] = this.nonProfits[event.target.id.split('-')[0]].contact_name;
		
		const recordInput = {
			apiName: NON_PROFIT_OBJECT.objectApiName,
			fields
		};
		createRecord(recordInput).then(account => {
			const event = new ShowToastEvent({
				title: 'Non Profit',
				message: 'Non Profit record created!!',
				variant: 'success',
				mode: 'dismissable'
			});
			this.dispatchEvent(event);

			eval("$A.get('e.force:refreshView').fire();");

		}).catch(error => {

			this.error = error;
		});
	}
}