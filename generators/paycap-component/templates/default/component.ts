import { Component, OnInit, ChangeDetectionStrategy } from '@angular/core';
import { Store } from '@ngrx/store'

@Component({
  selector: '<%= c.selector %>',
  templateUrl: './ui.<%= c.templateType %>',
  styleUrls: ['./style.scss'],
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class <%= c.componentName %> implements OnInit {

  constructor(private _store: Store<any>) { /* EMPTY */ }

  ngOnInit() { /* EMPTY */ }

}
