import { ModuleWithProviders } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';

import { Component } from './component';

export const routes: Routes = [
  { path: '', component: Component }
];

export const Routing: ModuleWithProviders = RouterModule.forChild(routes);
