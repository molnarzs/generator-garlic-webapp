import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { <%= c.moduleName %> as NativeModule } from 'common/native/<%= c.baseFolder %>/<%= c.componentSlug %>';
import { <%= c.componentName %> } from './component';

@NgModule({
  imports: [CommonModule, NativeModule],
  declarations: [<%= c.componentName %>],
  exports: [<%= c.componentName %>],
  providers: []
})
export class <%= c.moduleName %> { }
