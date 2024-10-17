<div class="card mb-4">
  <img [src]="image" class="card-img-top" alt="{{ title }}">
  <div class="card-body">
    <h5 class="card-title">{{ title }}</h5>
    <div *ngFor="let category of supportLinks">
      <h6 class="category-header">{{ category.category }}</h6>
      <ul class="list-group mb-3">
        <li class="list-group-item" *ngFor="let link of category.links">
          <a [routerLink]="link.route">{{ link.label }}</a>
        </li>
      </ul>
    </div>
  </div>
</div>
