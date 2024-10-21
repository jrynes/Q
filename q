import { Injectable } from '@angular/core';
import homeData from '../assets/home-sections.json'; // Adjust the path to where your JSON is located

@Injectable({
  providedIn: 'root'
})
export class HomeService {
  private homeSections = homeData.homeSections;

  getSectionsForRole(role: string) {
    return this.homeSections.map(section => {
      const hasAllAccess = section.roles[role]?.includes('*');

      const subSections = section.subSections.map(subSection => {
        const filteredLinks = hasAllAccess
          ? subSection.links // Give access to all links if wildcard present
          : subSection.links.filter(link =>
              section.roles[role]?.includes(link.name)
            );

        return {
          ...subSection,
          links: filteredLinks // Set filtered links for sub-sections
        };
      }).filter(subSection => subSection.links.length > 0); // Remove empty sub-sections

      const sectionLinks = section.links || [];
      const combinedLinks = [
        ...subSections.reduce((acc, curr) => [...acc, ...curr.links], []),
        ...hasAllAccess
          ? sectionLinks
          : sectionLinks.filter(link => section.roles[role]?.includes(link.name))
      ];

      return {
        ...section,
        subSections: subSections,
        links: combinedLinks // Set combined links to the section
      };
    });
  }
}
