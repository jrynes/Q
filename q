    // Convert Set back to array
    const finalLinks = Array.from(combinedLinks).map(name => {
      const link = section.links?.find(link => link.name === name) || 
                   section.subSections.flatMap(sub => sub.links).find(link => link.name === name);
      return link || null; // Return null if link is not found
    }).filter(link => link !== null); // Filter out null values

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
