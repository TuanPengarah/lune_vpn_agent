class ServerLocation {
  int? id;
  String? name;
  ServerLocation(this.id, this.name);
  static List<ServerLocation> getServerLocation() {
    return <ServerLocation>[
      ServerLocation(1, 'Malaysia'),
      ServerLocation(2, 'Singapore'),
    ];
  }
}
