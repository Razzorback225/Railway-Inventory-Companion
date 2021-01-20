class Rail {
  String partNumber;
  String partGauge;
  String partType;
  String partQuantity;

  Rail(this.partNumber, this.partGauge, this.partType, this.partQuantity);

  String toString() => "{$partNumber, $partGauge, $partType, $partQuantity}";
}
