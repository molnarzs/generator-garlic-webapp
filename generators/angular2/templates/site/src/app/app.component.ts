import { Component } from '@angular/core';

import { MAIN } from './shared/constant/main';

@Component({
    selector: 'app-main',
    templateUrl: 'app.component.jade',
    styleUrls: ['app.component.scss']
})
export class AppComponent {
    public appBrand: string;

    constructor() {
        this.appBrand = MAIN.APP.BRAND;
    }
}
