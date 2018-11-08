import { ActionReducerMap } from '@ngrx/store';
import { IState } from './state';
import { routerReducer } from '@ngrx/router-store';

export const reducer: ActionReducerMap<IState> = {
  router: routerReducer
};
