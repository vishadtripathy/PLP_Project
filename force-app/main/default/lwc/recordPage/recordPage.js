import { LightningElement, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class EmployeeRecordPage extends NavigationMixin(LightningElement) {

    @api recordId;
    @api objectApiName;
    navigateToRecordEditPage() 
    {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.recordId,
                actionName: 'edit'
            }
        });
    }

    
}