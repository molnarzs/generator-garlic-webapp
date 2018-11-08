import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { BrowserModule } from '@angular/platform-browser';

import { BrowserAnimationsModule } from '@angular/platform-browser/animations';

import { AppComponent } from './app.component';
import { routing } from './app-routing.module';

import { APP_DECLARATIONS } from './app.declarations';
import { APP_ENTRY_COMPONENTS } from './app.entry-components';
import { APP_IMPORTS } from './app.imports';
import { APP_PROVIDERS } from './app.providers';

@NgModule({
  declarations: [AppComponent, APP_DECLARATIONS],
  providers: [...APP_PROVIDERS],
  imports: [
    CommonModule,
    BrowserAnimationsModule,
    BrowserModule.withServerTransition({ appId: '<%= conf.appNameKC %>' }),
    APP_IMPORTS,
    routing
  ],
  bootstrap: [AppComponent],
  entryComponents: [APP_ENTRY_COMPONENTS]
})
export class AppModule {}
