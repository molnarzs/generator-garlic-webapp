import { Component } from '@angular/core';

@Component({
    selector: '<%= conf.selectorPrefix %>-devapp',
    templateUrl: 'app.component.pug'
})
export class AppComponent {
    public appBrand: string;

    // constructor() {}
}
