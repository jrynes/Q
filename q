<div class="main-navigation-container">
  <nav class="navbar navbar-expand-lg navbar-light bg-light">
    <button class="navbar-toggler" type="button" (click)="snav.toggle()" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="margin-left-15">
      <span>Patent Center Support</span>
    </div>
    <span class="fill-toolbar-space"></span>
  </nav>
  
  <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
    <div class="container-fluid">
      <button class="btn btn-light" routerLink="/" routerLinkActive="active_nav">Home</button>

      <ng-container *ngFor="let section of homeData.sections">
        <div *ngIf="userHasAccessToSection(section.title)" class="dropdown">
          <button class="btn btn-light dropdown-toggle" id="{{section.title}}MenuButton" data-bs-toggle="dropdown" aria-expanded="false">
            {{ section.title }}
          </button>
          <ul class="dropdown-menu" aria-labelledby="{{section.title}}MenuButton">
            <ng-container *ngFor="let subSection of section.subSections">
              <li><h6 class="dropdown-header">{{ subSection.title }}</h6></li>
              <ng-container *ngFor="let link of subSection.links">
                <li><a class="dropdown-item" [routerLink]="link.url" routerLinkActive="active_nav">{{ link.name }}</a></li>
              </ng-container>
            </ng-container>
          </ul>
        </div>
      </ng-container>
    </div>
  </nav>
</div>
