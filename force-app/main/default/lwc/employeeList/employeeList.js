import { LightningElement, wire } from 'lwc';
import certificationResources from '@salesforce/resourceUrl/certification_management';
// import getAllEmployees from '@salesforce/apex/EmployeeController.getAllEmployees';
import searchEmployees from '@salesforce/apex/EmployeeController.searchEmployees';
import { NavigationMixin } from 'lightning/navigation';

export default class EmployeeList extends NavigationMixin(LightningElement) {
	searchTerm = '';
	@wire(searchEmployees, {searchTerm: '$searchTerm'})
	employees;
    //error;
    appResources = {
		employeeImage: certificationResources + '/img/employee.jfif',
		boxImage: certificationResources + '/img/box.jpg',
    };
    // connectedCallback() {
	// 	this.loadEmployees();
	// }
	// loadEmployees() {
	// 	getAllEmployees()
	// 		.then(result => {
	// 			this.employees = result;
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
		return (this.employees.data.length > 0);
	}


	handleOpenRecordClick(event) {

		this[NavigationMixin.Navigate]({
			type: 'standard__recordPage',
			attributes: {
				recordId: event.target.value,
				objectApiName: 'Employee__c',
				actionName: 'view',
			},
		});
	}
}