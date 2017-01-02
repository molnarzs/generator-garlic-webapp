import { Component, OnInit, ChangeDetectionStrategy} from '@angular/core';

@Component({
  selector: '<%= c.selector %>',
  templateUrl: './ui',
  styleUrls: ['./style'],
  // changeDetection: ChangeDetectionStrategy.OnPush
})
export class <%= c.componentName %> implements OnInit {

  constructor() { }

  ngOnInit() {
  }

}
