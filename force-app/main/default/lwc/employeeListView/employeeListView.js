import { LightningElement,track, wire  } from 'lwc';
import { getListUi } from 'lightning/uiListApi';

import EMPLOYEE_OBJECT from '@salesforce/schema/Employee__c';
import { NavigationMixin } from 'lightning/navigation';
export default class EmployeeListView extends NavigationMixin(LightningElement) {
    @track listViewResult;
    @track error;
    @wire(getListUi, {
        objectApiName: EMPLOYEE_OBJECT,
        listViewApiName: 'All'
    })
    listView({error,data}) {
        if (data) {
            this.listViewResult = data.records.records;
        } else if (error) {
            this.error = error;
        }
    }

    handleEmpView(event)
    {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: event.target.value,
                objectApiName: 'Employee__c',
                actionName: 'view',
            },
        });
    }

    createNewEmployee()
    {
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Employee__c',
                actionName: 'new'
            }
        });
    }

}