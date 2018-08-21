import { CUSTOM_ELEMENTS_SCHEMA, Pipe, PipeTransform } from '@angular/core';
import { async, ComponentFixture, TestBed } from '@angular/core/testing';
import { StoreModule } from '@ngrx/store';

import { reducer } from 'common/native/store';

import { <%= c.componentName %> } from '../';

@Pipe({ name: 'translate' })
class MockTranslatePipe implements PipeTransform {
  transform(value: string): string {
    return `translated: ${value}`;
  }
}

describe('<%= c.componentName %>', () => {
  let component: <%= c.componentName %>;
  let fixture: ComponentFixture<<%= c.componentName %>>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      imports: [StoreModule.forRoot(reducer)],
      declarations: [<%= c.componentName %>, MockTranslatePipe],
      schemas: [ CUSTOM_ELEMENTS_SCHEMA ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(<%= c.componentName %>);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('it should be created', () => {
    expect(component).toBeTruthy();
  });
});
