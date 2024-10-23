.dropdown-menu {
  background-color: white;
  border: 1px solid #dee2e6; 
  opacity: 0; // Start as invisible
  transform: translateY(-10px); // Start slightly above
  transition: opacity 0.3s ease, transform 0.3s ease; // Transition for opacity and transform

  &.show { // When the dropdown is shown
    opacity: 1; // Fully visible
    transform: translateY(0); // Move to original position
  }
}

