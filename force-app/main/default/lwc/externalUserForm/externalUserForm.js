import { LightningElement } from 'lwc';
import submitExternalUser from '@salesforce/apex/ExternalUserService.submitExternalUser';

export default class ExternalUserForm extends LightningElement {
    name = '';
    email = '';
    response;
    error;
    isSubmitting = false;

    handleNameChange(event) {
        this.name = event.target.value;
    }

    handleEmailChange(event) {
        this.email = event.target.value;
    }

    get isFormInvalid() {
        return !this.name || !this.email;
    }

    async handleSubmit() {
        this.error = undefined;
        this.response = undefined;
        this.isSubmitting = true;
        try {
            const result = await submitExternalUser({
                name: this.name,
                email: this.email
            });
            this.response = result;
        } catch (err) {
            this.error = err.body ? err.body.message : 'Unknown error occurred';
        } finally {
            this.isSubmitting = false;
        }
    }
}