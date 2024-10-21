<!-- panel.component.html -->
<div class="card w-100">
  <img [src]="image" class="card-img-top d-none d-sm-block" alt="{{ title }}">
  <div class="bg-light p-2">
    <h3 class="m-0 text-uppercase text-shadow text-primary">{{ title }}</h3>
  </div>
  <div class="card-body">
    <div *ngFor="let subSection of subSections">
      <h4 class="card-title">{{ subSection.subHeading }}</h4>
      <ul class="list-unstyled">
        <li *ngFor="let link of subSection.links">
          <a [routerLink]="link.url">{{ link.name }}</a>
        </li>
      </ul>
    </div>

    <h4 class="card-title" *ngIf="links.length > 0">Other Links</h4>
    <ul class="list-unstyled" *ngIf="links.length > 0">
      <li *ngFor="let link of links">
        <a [routerLink]="link.url">{{ link.name }}</a>
      </li>
    </ul>
  </div>
</div>
