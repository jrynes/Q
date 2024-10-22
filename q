  // Main method to check if a route can be activated
  async canActivate(route: ActivatedRouteSnapshot, state: RouterStateSnapshot): Promise<boolean> {
    // First, check if OktaAuth instance is not null
    if (!this.oktaAuth) {
      console.error("OktaAuth instance is null");
      this.handleLoginRedirect(state.url);
      return false; // Deny access if OktaAuth is not available
    }

    // Check if the user is logged in
    const isAuthenticated = await this.oktaAuth.isAuthenticated();
    if (!isAuthenticated) {
      console.log('User is not authenticated, redirecting to login.');
      this.handleLoginRedirect(state.url);
      return false; // Deny access if not authenticated
    }

    // Initialize user information
    this.user.init();
    await this.authService.checkAuthentication();

    // Get user roles from the user service
    const userRoles = this.user.getRoles(); // Assume this method fetches user roles
    console.log('User roles:', userRoles);

    // Get the required scopes for the current route
    const requiredScopes = this.getScopesForRoute(state.url);
    console.log('Required scopes:', requiredScopes);

    // Handle the case when requiredScopes is empty
    if (requiredScopes.length === 0) {
      console.log('No required scopes for this route, access denied.');
      this.router.navigate(['/access-denied']); // Redirect to access denied page
      return false; // Deny access
    }

    // Retrieve the current token from local storage
    try {
      this.currentToken = JSON.parse(localStorage.getItem('okta-token-storage') || '{}');
    } catch (error) {
      console.error('Token retrieval failed:', error);
      this.currentToken = {};
    }

    // If there is a current token, update session storage with its scopes
    if (this.currentToken) {
      sessionStorage.setItem('originalOktaToken', JSON.stringify(this.currentToken));
      sessionStorage.setItem("oktaToken", this.currentToken.accessToken.accessToken);

      const existingScopes = sessionStorage.getItem('oktaScopes')?.split(',') || [];
      const newScopes = this.currentToken.accessToken.scopes.filter((scope: string) => !existingScopes.includes(scope));
      const updatedScopes = [...existingScopes, ...newScopes];
      sessionStorage.setItem('oktaScopes', updatedScopes.join(','));
    }

    // Check if the user has the required scopes
    if (await this.accessTokenCheckService.hasRequiredScopes(requiredScopes)) {
      console.log('User has required scopes, access granted.');
      return true; // Allow access if the user has the required scopes
    }

    // Try to get a new token from Okta without prompting the user
    try {
      console.log("Requesting new scopes from Okta...");
      const res = await this.oktaAuth.token.getWithoutPrompt({
        responseType: ['id_token', 'token'],
        scopes: requiredScopes,
      });

      // If successful, update session storage with the new token's scopes
      if (res.tokens?.accessToken?.scopes) {
        const newScopes = res.tokens.accessToken.scopes;
        const existingScopes = sessionStorage.getItem('oktaScopes')?.split(',') || [];
        const updatedScopes = [...new Set([...existingScopes, ...newScopes])];
        sessionStorage.setItem('oktaScopes', updatedScopes.join(','));

        // Check again if the user has the required scopes
        if (await this.accessTokenCheckService.hasRequiredScopes(requiredScopes)) {
          console.log('User has new required scopes after token refresh, access granted.');
          return true; // Allow access if scopes are valid now
        }
      }
    } catch (error) {
      // If token retrieval or validation fails, log the error and redirect to login
      console.error('Token retrieval or validation failed:', error);
      await this.oktaAuth.signInWithRedirect({ scopes: requiredScopes });
    }

    // Deny access if all checks fail
    console.log('Access denied for route:', state.url);
    return false;
  }

  private async handleLoginRedirect(originalUri: string) {
    try {
      const isAuthenticated = await this.oktaAuth.isAuthenticated();
      if (isAuthenticated) {
        this.oktaAuth.setOriginalUri(originalUri);
        sessionStorage.setItem("url", originalUri);
        await this.oktaAuth.signInWithRedirect();
      } else {
        this.router.navigate(['/']);
      }
    } catch (err) {
      console.error('Login redirect failed:', err);
    }
  }

  private getScopesForRoute(url: string): string[] {
    const section = this.homeService.homeSections.find(section =>
      section.links.some(link => link.url === url) || 
      section.subSections.some(sub => sub.links.some(link => link.url === url))
    );

    if (section) {
      const requiredScopes = Object.keys(section.scopes).reduce((acc, role) => {
        if (section.roles[role]?.includes('*') || section.roles[role]?.some(roleName => this.user.getRoles().includes(roleName))) {
          return [...acc, ...section.scopes[role]];
        }
        return acc;
      }, []);
      console.log('Required scopes for route:', requiredScopes);
      return requiredScopes;
    }

    return [];
  }
}
