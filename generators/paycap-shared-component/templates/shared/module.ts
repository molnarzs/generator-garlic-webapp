import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { <%= c.componentName %> } from './component';

@NgModule({
  imports: [CommonModule],
  declarations: [<%= c.componentName %>],
  exports: [<%= c.componentName %>],
  providers: []
})
export class <%= c.moduleName %> { }
