import { Component, Injector } from '@angular/core';
import { Store } from '@ngrx/store'

@Component({
  selector: '<%= c.nativeSelector %>',
  template: ''
})
export class <%= c.componentName %> {
  protected _store: Store <any>

  constructor(private readonly _injector: Injector) {
    this._store = this._injector.get<Store<any>>(Store);
  }
}
