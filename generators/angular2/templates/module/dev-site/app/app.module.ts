import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';

import { HomeModule } from './home/home.module';
import { AppComponent } from './app.component';
import { routing } from './app-routing.module';

@NgModule({
    declarations: [
        AppComponent
    ],
    imports: [
        BrowserModule,
        HomeModule,
        routing,
    ],
    bootstrap: [ AppComponent ]
})
export class AppModule {
}
