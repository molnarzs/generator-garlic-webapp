import { Component, OnInit } from '@angular/core';
import { Store } from '@ngrx/store'

@Component({
  selector: '<%= c.selector %>',
  template: ''
})
export class <%= c.componentName %> implements OnInit {

  constructor(private _store: Store<any>) { /* EMPTY */ }

  ngOnInit() { /* EMPTY */ }

}
