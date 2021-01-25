class Rail {
  String partNumber;
  String partGauge;
  String partType;
  String partQuantity;
  String partBrand;
  String partDesc;
  String partImageUrl;

  Rail(this.partNumber, this.partGauge, this.partType, this.partQuantity, this.partBrand, this.partDesc, this.partImageUrl);

  String toString() => "{$partNumber, $partGauge, $partType, $partQuantity, $partBrand, $partDesc, $partImageUrl}";
}
