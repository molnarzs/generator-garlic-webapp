/* tslint:disable:no-unused-variable */

import { TestBed, async, inject } from '@angular/core/testing';
import { <%= c.serviceName %> } from '..';

describe('<%= c.serviceName %>', () => {
  beforeEach(() => {
    TestBed.configureTestingModule({
      providers: [<%= c.serviceName %>]
    });
  });

  it('should ...', inject([<%= c.serviceName %>], (service: <%= c.serviceName %>) => {
    expect(service).toBeTruthy();
  }));
});
