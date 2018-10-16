import { Component, OnInit, Injector } from '@angular/core';
import { Store } from '@ngrx/store'

@Component({
  selector: '<%= c.nativeSelector %>',
  template: ''
})
export class <%= c.componentName %> implements OnInit {
  protected _store: Store < any >

  constructor(private _injector: Injector) { /* EMPTY */ }

  ngOnInit() {
    this._store = this._injector.get<Store<any>>(Store);
  }

}
