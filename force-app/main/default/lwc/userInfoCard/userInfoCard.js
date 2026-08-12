import { LightningElement, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import USER_ID from '@salesforce/user/Id';
import NAME_FIELD from '@salesforce/schema/User.Name';
import EMAIL_FIELD from '@salesforce/schema/User.Email';
import TITLE_FIELD from '@salesforce/schema/User.Title';

const FIELDS = [NAME_FIELD, EMAIL_FIELD, TITLE_FIELD];

export default class UserInfoCard extends LightningElement {
    userId = USER_ID;

    @wire(getRecord, { recordId: '$userId', fields: FIELDS })
    user;

    get name() {
        return this.user?.data?.fields?.Name?.value;
    }

    get email() {
        return this.user?.data?.fields?.Email?.value;
    }

    get title() {
        return this.user?.data?.fields?.Title?.value ?? 'No title set';
    }

    get hasError() {
        return this.user?.error;
    }
}