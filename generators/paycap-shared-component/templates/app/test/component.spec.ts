import { CUSTOM_ELEMENTS_SCHEMA } from '@angular/core';
import { async, ComponentFixture, TestBed } from '@angular/core/testing';
import { Store, StoreModule } from '@ngrx/store';
import { reducer, featureName } from '@features/common/foobar/store'
import { TranslateModule } from '@ngx-translate/core';
import { MockTranslatePipe } from 'common/native/test/mocks/mock-translate.pipe';

import { <%= c.componentName %> } from '../';

describe('<%= c.componentName %>', () => {
  let component: <%= c.componentName %>;
  let fixture: ComponentFixture<<%= c.componentName %>>;
  let store: Store<any>;

  const initTestBed = async () => {
    await TestBed.configureTestingModule({
      imports: [StoreModule.forRoot({}), StoreModule.forFeature(featureName, reducer), TranslateModule],
      declarations: [<%= c.componentName %>, MockTranslatePipe],
      schemas: [CUSTOM_ELEMENTS_SCHEMA]
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
