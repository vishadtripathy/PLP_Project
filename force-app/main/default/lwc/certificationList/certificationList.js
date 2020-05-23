//used wire services
import { LightningElement, wire } from 'lwc';
//to import the icons for the UI
import certificationResources from '@salesforce/resourceUrl/certification_management';
//to fetch data from the apex class
import searchCertifications from '@salesforce/apex/CertificationController.searchCertifications';
//to use navigation
import { NavigationMixin } from 'lightning/navigation';

export default class CertificationList extends NavigationMixin(LightningElement) {
	searchTerm = '';
	@wire(searchCertifications, {searchTerm: '$searchTerm'})
	certifications;
    
    appResources = {
		certificationImage: certificationResources + '/img/certification.png',
		boxImage: certificationResources + '/img/box.jpg',
    };
	
	
	handleSearchTermChange(event) {
		// Debouncing this method: do not update the reactive property as
		// long as this function is being called within a delay of 300 ms.
		// This is to avoid a very large number of Apex method calls.
		window.clearTimeout(this.delayTimeout);
		const searchTerm = event.target.value;
		// eslint-disable-next-line @lwc/lwc/no-async-operation
		this.delayTimeout = setTimeout(() => {
			this.searchTerm = searchTerm;
		}, 300);
	}

	//to check whether any record is present or not
	get hasResults() {
		return (this.certifications.data.length > 0);
	}


	//used to navigate to the record page on button click
	handleOpenRecordClick(event) {

		this[NavigationMixin.Navigate]({
			type: 'standard__recordPage',
			attributes: {
				recordId: event.target.value,
				objectApiName: 'Certification__c',
				actionName: 'view',
			},
		});
	}
}