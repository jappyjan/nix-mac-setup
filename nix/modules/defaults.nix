{ ... }:

{
  system.defaults.NSGlobalDomain = {
    AppleInterfaceStyleSwitchesAutomatically = true;
  };

  system.defaults.dock = {
    autohide = true;
    show-recents = false;
  };

  system.defaults.finder = {
    FXPreferredViewStyle = "clmv";
    ShowHardDrivesOnDesktop = true;
    ShowExternalHardDrivesOnDesktop = true;
    ShowRemovableMediaOnDesktop = true;
    ShowMountedServersOnDesktop = true;
    NewWindowTarget = "Other";
    NewWindowTargetPath = "file:///Users/jappy/";
  };

  system.defaults.CustomUserPreferences."com.apple.finder" = {
    ShowRecents = false;
    ShowRecentTags = false;
    SidebarSharedSectionDisclosedState = false;
    SidebarTagsSectionDisclosedState = false;
  };
}
