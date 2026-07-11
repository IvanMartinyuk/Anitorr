enum SortDirection {
  descending('Descending'),
  ascending('Ascending');

  const SortDirection(this.label);

  final String label;

  bool get isDescending => this == SortDirection.descending;

  SortDirection get toggled {
    return switch (this) {
      SortDirection.descending => SortDirection.ascending,
      SortDirection.ascending => SortDirection.descending,
    };
  }
}
