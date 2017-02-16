import { ModuleWithProviders } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';

export const routes: Routes = [
  // { path: '', component: HomeComponent }
];

export const routing: ModuleWithProviders = RouterModule.forChild(routes);
