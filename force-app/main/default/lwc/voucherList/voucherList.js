import { LightningElement, wire } from 'lwc';
import certificationResources from '@salesforce/resourceUrl/certification_management';
import searchVouchers from '@salesforce/apex/VoucherController.searchVouchers';
import { NavigationMixin } from 'lightning/navigation';

export default class VoucherList extends NavigationMixin(LightningElement) {
	searchTerm = '';
	@wire(searchVouchers, {searchTerm: '$searchTerm'})
	vouchers;
    //error;
    appResources = {
        voucherImage: certificationResources + '/img/voucher.png',
        boxImage: certificationResources + '/img/box.jpg',
    };
    // connectedCallback() {
	// 	this.loadVouchers();
	// }
	// loadVouchers() {
	// 	getAllVouchers()
	// 		.then(result => {
	// 			this.vouchers = result;
	// 		})
	// 		.catch(error => {
	// 			this.error = error;
	// 		});
    // }
	
	
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
	get hasResults() {
		return (this.vouchers.data.length > 0);
	}

    handleOpenRecordClick(event) {

		this[NavigationMixin.Navigate]({
			type: 'standard__recordPage',
			attributes: {
				recordId: event.target.value,
				objectApiName: 'Voucher__c',
				actionName: 'view',
			},
		});
	}
}