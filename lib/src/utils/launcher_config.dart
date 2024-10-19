class LauncherConfig {
  final Function() onLaunch;
  final Function() onKill;

  const LauncherConfig({required this.onLaunch, required this.onKill});
}
