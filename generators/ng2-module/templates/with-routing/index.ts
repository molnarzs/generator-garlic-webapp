import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { <%= c.routingModuleName %> } from './routing.module';

@NgModule({
  imports: [
    CommonModule,
    <%= c.routingModuleName %>
  ],
  declarations: [],
  providers: []
})
export class <%= c.moduleName %> { }
