import { Component, ChangeDetectionStrategy } from '@angular/core';

import { <%= c.componentName %> as NativeComponent } from 'common/native/<%= c.baseFolder %>/components/<%= c.componentSlug %>';

@Component({
  selector: '<%= c.selector %>',
  templateUrl: './ui.<%= c.templateType %>',
  styleUrls: ['./style.scss'],
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class <%= c.componentName %> extends NativeComponent { }
