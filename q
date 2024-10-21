<!-- panel.component.html -->
<div class="card mb-4">
  <img [src]="image" class="card-img-top" alt="{{ title }}" *ngIf="image">
  <div class="card-body">
    <div class="title-background">
      <h5 class="card-title">{{ title }}</h5>
    </div>

    <!-- Iterate through sections -->
    <div *ngFor="let section of sections">
      <h6 class="section-header">{{ section.sectionTitle }}</h6>
      
      <!-- Iterate through articles within the section -->
      <div *ngFor="let article of section.articles">
        <h6 class="article-header">{{ article.articleTitle }}</h6>
        <ul class="list-group mb-3">
          <li class="list-group-item" *ngFor="let link of article.links">
            <a [routerLink]="link.url" class="link">{{ link.name }}</a>
          </li>
        </ul>
      </div>
    </div>
  </div>
</div>
