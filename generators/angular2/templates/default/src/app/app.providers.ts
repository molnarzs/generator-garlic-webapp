import { REDUCER_TOKEN, getReducers } from './store';
export const APP_PROVIDERS = [{ provide: REDUCER_TOKEN, useFactory: getReducers }];
