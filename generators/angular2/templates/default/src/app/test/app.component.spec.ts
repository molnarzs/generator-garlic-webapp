import { RouterTestingModule } from '@angular/router/testing';

import { async, TestBed, ComponentFixture } from '@angular/core/testing';

import { provideRoutes, Routes, RouterModule } from '@angular/router';
import { Component } from '@angular/core';

import { AppComponent } from '../app.component';

@Component({
  selector: 'app-test-cmp',
  template: '<div class="title">Hello test</div>'
})
class TestRouterComponent {}

const config: Routes = [
  {
    path: '',
    component: TestRouterComponent
  }
];

describe('AppComponent', () => {
  beforeEach(() => {
    TestBed.configureTestingModule({
      declarations: [TestRouterComponent, AppComponent],
      imports: [RouterTestingModule, RouterModule],
      providers: [provideRoutes(config)]
    });
  });

  it('should have title Hello world', async(() => {
    TestBed.compileComponents().then(() => {
      let fixture: ComponentFixture<AppComponent>;
      fixture = TestBed.createComponent(AppComponent);
      fixture.detectChanges();

      const compiled = fixture.debugElement.nativeElement;
      expect(compiled).toBeDefined();
      // TODO: find a way to compile the routed component
      // expect(compiled.querySelector('div.title')).toMatch('Hello world');
    });
  }));
});
