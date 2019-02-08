import { CUSTOM_ELEMENTS_SCHEMA } from '@angular/core';
import { ComponentFixture, TestBed } from '@angular/core/testing';
import { StoreModule, Store } from '@ngrx/store';
const __store = require('@ngrx/store');

import { reducer, featureName } from '../../../store';
import { <%= c.componentName %> } from '../';

describe('<%= c.componentName %>', () => {
  let component: <%= c.componentName %>;
  let fixture: ComponentFixture<<%= c.componentName %>>;
  let store: Store<any>;

  const initTestBed = () => {
    TestBed.configureTestingModule({
      imports: [StoreModule.forRoot({}), StoreModule.forFeature(featureName, reducer)],
      declarations: [<%= c.componentName %>],
      schemas: [ CUSTOM_ELEMENTS_SCHEMA ]
    })
      .compileComponents();

    fixture = TestBed.createComponent(<%= c.componentName %>);
    component = fixture.componentInstance;
    fixture.detectChanges();
    store = TestBed.get(Store);
    store.dispatch = jest.fn();
  }

  beforeEach(initTestBed)

  afterEach(() => {
    fixture.destroy();
  });

  it('it should be created', () => {
    expect(component).toBeTruthy();
    expect(fixture).toMatchSnapshot()
  });
});
