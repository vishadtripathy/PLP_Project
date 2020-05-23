import { LightningElement } from 'lwc';
//to import the icons for the UI
import certificationResources from '@salesforce/resourceUrl/certification_management';
//to fetch data from the apex class
import getAllCertificationRequests from '@salesforce/apex/CertificationRequestController.getAllCertificationRequests';
//to use navigation
import { NavigationMixin } from 'lightning/navigation';

export default class CertificationRequestList extends NavigationMixin(LightningElement) {
    
	certificationRequests;
	error;
	

    appResources = {
        certificationRequestImage: certificationResources + '/img/certificationRequest.png',
        boxImage: certificationResources + '/img/box.jpg',
	};
	
	//to assign the returned value to the certificationRequests variable and errors to the error variable
    connectedCallback() {
		this.loadCertificationRequests();
	}
	loadCertificationRequests() {
		getAllCertificationRequests()
			.then(result => {
				this.certificationRequests = result;
			})
			.catch(error => {
				this.error = error;
			});
    }
	

	//used to navigate to the record page on button click
    handleOpenRecordClick(event) {

		this[NavigationMixin.Navigate]({
			type: 'standard__recordPage',
			attributes: {
				recordId: event.target.value,
				objectApiName: 'Certification_Request__c',
				actionName: 'view',
			},
		});
	}
}