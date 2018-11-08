import { InjectionToken } from '@angular/core';
import { ActionReducerMap, ActionReducer } from '@ngrx/store';
import { storeLogger } from 'ngrx-store-logger';
import { storeFreeze } from 'ngrx-store-freeze';
import { environment } from 'environments/environment';
import { reducer } from './reducer';

import { IState } from './state';

export function logger(_reducer: ActionReducer<any>): any {
  return storeLogger()(_reducer);
}

const metaReducers = [logger];

if (!environment.production) {
  metaReducers.push(storeFreeze);
}

export { metaReducers };

export const REDUCER_TOKEN = new InjectionToken<ActionReducerMap<IState>>('Registered Reducers');

export function getReducers() {
  return reducer;
}
