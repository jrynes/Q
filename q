getSectionsForRoles(roles: string[]) {
  return this.homeSections.map(section => {
    console.log("Processing section:", section.sectionTitle);
    
    let combinedLinks = new Set<string>(); // Use Set to avoid duplicates
    const hasAllAccess = roles.some(role => section.roles[role?.toLowerCase()]?.includes('*'));

    console.log("Has all access:", hasAllAccess);

    // Skip section if there are no roles
    if (Object.keys(section.roles).length === 0) {
      console.log("No roles for section:", section.sectionTitle);
      return null; // Exclude section if it has no roles
    }

    // Gather links from the section's links
    const sectionLinks = section.links || []; // Ensure sectionLinks is an array
    console.log("Initial section links:", sectionLinks);

    // Add direct section links based on the current role
    sectionLinks.forEach(link => {
      if (hasAllAccess || roles.some(role => section.roles[role?.toLowerCase()]?.includes(link.name))) {
        console.log("Adding direct link:", link.name);
        combinedLinks.add(link.name); // Add to set to avoid duplicates
      } else {
        console.log("Skipping link due to role restrictions:", link.name);
      }
    });

    // Iterate through roles to gather sub-section links
    roles.forEach(role => {
      section.subSections.forEach(subSection => {
        console.log("Processing sub-section:", subSection.subHeading);
        
        const filteredLinks = hasAllAccess
          ? subSection.links // Give access to all links if wildcard present
          : subSection.links.filter(link =>
              section.roles[role?.toLowerCase()]?.includes(link.name)
            );

        console.log("Filtered links for role", role, "in sub-section:", filteredLinks);

        // Add filtered links to the combined set
        filteredLinks.forEach(link => {
          console.log("Adding sub-section link:", link.name);
          combinedLinks.add(link.name); // Add to set to avoid duplicates
        });
      });
    });

    // Convert Set back to array
    const finalLinks = Array.from(combinedLinks).map(name => {
      const linkFromSection = section.links?.find(link => link.name === name);
      const linkFromSubSections = section.subSections?.flatMap(sub => sub.links).find(link => link.name === name);
      
      console.log("Checking for link:", name);
      console.log("Found link in section:", linkFromSection);
      console.log("Found link in sub-sections:", linkFromSubSections);
      
      return linkFromSection || linkFromSubSections || null; // Return the found link or null
    }).filter(link => link !== null); // Filter out null values

    console.log("Final links for section:", finalLinks);

    // Return section only if it has valid links or sub-sections
    return (finalLinks.length > 0 || section.subSections.some(sub => sub.links.length > 0))
      ? {
          ...section,
          subSections: section.subSections.filter(sub => sub.links.length > 0), // Keep filtered sub-sections
          links: finalLinks // Set combined links to the section
        }
      : null; // Return null if no links or valid sub-sections
  }).filter(section => section !== null); // Filter out null sections
}
