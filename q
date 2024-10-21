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

      // Filter and gather links from sub-sections
      const subSections = section.subSections.map(subSection => {
        const filteredLinks = hasAllAccess
          ? subSection.links // Give access to all links if wildcard present
          : subSection.links.filter(link =>
              roles.some(role => section.roles[role]?.includes(link.name))
            );

        // Add the filtered links to the combined set
        filteredLinks.forEach(link => combinedLinks.add(link.name)); // Avoid duplicates

        return {
          ...subSection,
          links: filteredLinks // Set filtered links for sub-sections
        };
      }).filter(subSection => subSection.links.length > 0); // Remove empty sub-sections

      // Add section links based on current roles
      const sectionLinks = section.links || [];
      sectionLinks.forEach(link => {
        if (roles.some(role => section.roles[role]?.includes(link.name))) {
          combinedLinks.add(link.name); // Add to set to avoid duplicates
        }
      });

      // Convert Set back to array
      const finalLinks = Array.from(combinedLinks).map(name =>
        section.links.find(link => link.name === name) || 
        section.subSections.flatMap(sub => sub.links).find(link => link.name === name)
      );

      // Check if there are any links available before returning the section
      if (finalLinks.length > 0 || subSections.length > 0) {
        return {
          ...section,
          subSections: subSections, // Keep the filtered sub-sections
          links: finalLinks // Set combined links to the section
        };
      }
      return null; // Return null if no links or sub-sections are available
    }).filter(section => section !== null); // Filter out null sections
  }
}
