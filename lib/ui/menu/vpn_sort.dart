import 'package:flutter/material.dart';

class MenuVpnSort {
  static const items = <IconMenu>[
    all,
    active,
    pending,
    expired,
    canceled,
  ];

  static const all = IconMenu(
    text: 'All',
    icon: Icons.view_stream,
  );

  static const active = IconMenu(
    text: 'Active',
    icon: Icons.done,
  );
  static const canceled = IconMenu(
    text: 'Canceled',
    icon: Icons.cancel_presentation,
  );
  static const pending = IconMenu(
    text: 'Pending',
    icon: Icons.pending,
  );
  static const expired = IconMenu(
    text: 'Expired',
    icon: Icons.error,
  );
}

class MenuVpnAscending {
  static const items = <IconMenu>[
    ascending,
    descending,
  ];
  static const ascending = IconMenu(
    text: 'Ascending',
    icon: Icons.expand_less,
  );
  static const descending = IconMenu(
    text: 'Descending',
    icon: Icons.expand_more,
  );
}

class IconMenu {
  final String text;
  final IconData icon;

  const IconMenu({
    required this.text,
    required this.icon,
  });
}
