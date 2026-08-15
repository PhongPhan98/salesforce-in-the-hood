import { LightningElement, wire } from 'lwc';
import getExternalUsers from '@salesforce/apex/ExternalUserService.getExternalUsers';

const COLUMNS = [
    { label: 'Name', fieldName: 'name' },
    { label: 'Username', fieldName: 'username' },
    { label: 'Email', fieldName: 'email' },
    { label: 'City', fieldName: 'city' }
];

export default class ExternalUserList extends LightningElement {
    columns = COLUMNS;
    users = [];
    error;
    isLoading = true;

   @wire(getExternalUsers)
    wiredUsers({ data, error }) {
        this.isLoading = false;
        console.log('WIRE DATA:', JSON.stringify(data));
        console.log('WIRE ERROR:', JSON.stringify(error));
        if (data) {
            this.users = data.map(u => ({
                id: u.id,
                name: u.name,
                username: u.username,
                email: u.email,
                city: u.address ? u.address.city : ''
            }));
            this.error = undefined;
        } else if (error) {
            this.error = error.body ? error.body.message : 'Unknown error occurred';
            this.users = [];
        }
    }

    get hasUsers() {
        return this.users && this.users.length > 0;
    }

    get hasNoUsers() {
        return !this.isLoading && !this.error && this.users.length === 0;
    }
}