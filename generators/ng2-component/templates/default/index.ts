import { Component, OnInit, ChangeDetectionStrategy } from '@angular/core';

@Component({
  selector: '<%= c.selector %>',
  templateUrl: './ui.<%= c.templateType %>',
  styleUrls: ['./style.scss']
  // changeDetection: ChangeDetectionStrategy.OnPush
})
export class <%= c.componentName %> implements OnInit {

  constructor() { }

  ngOnInit() {
  }

}
