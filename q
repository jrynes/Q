import { Injectable } from '@angular/core';
import homeData from '../assets/home-sections.json'; // Adjust the path to where your JSON is located

@Injectable({
  providedIn: 'root'
})
export class HomeService {
  private homeSections = homeData.homeSections;

  getSectionsForRoles(roles: string[]) {
    return this.homeSections.map(section => {
      // Initialize combined links and sub-sections
      let combinedLinks = new Set<string>(); // Use Set to avoid duplicates

      // Determine if any role has access to all links
      const hasAllAccess = roles.some(role => section.roles[role]?.includes('*'));

      // Iterate through roles to gather links
      roles.forEach(role => {
        // Filter sub-section links based on current role
        const subSections = section.subSections.map(subSection => {
          const filteredLinks = hasAllAccess
            ? subSection.links // Give access to all links if wildcard present
            : subSection.links.filter(link =>
                section.roles[role]?.includes(link.name)
              );

          // Add the filtered links to the combined set
          filteredLinks.forEach(link => combinedLinks.add(link.name)); // Avoid duplicates

          return {
            ...subSection,
            links: filteredLinks // Set filtered links for sub-sections
          };
        }).filter(subSection => subSection.links.length > 0); // Remove empty sub-sections

        // Add section links based on current role
        const sectionLinks = section.links || [];
        sectionLinks.forEach(link => {
          if (section.roles[role]?.includes(link.name)) {
            combinedLinks.add(link.name); // Add to set to avoid duplicates
          }
        });
      });

      // Convert Set back to array
      const finalLinks = Array.from(combinedLinks).map(name =>
        section.links.find(link => link.name === name) || 
        section.subSections.flatMap(sub => sub.links).find(link => link.name === name)
      );

      return {
        ...section,
        subSections: section.subSections, // Keep the original sub-sections
        links: finalLinks // Set combined links to the section
      };
    });
  }
}
