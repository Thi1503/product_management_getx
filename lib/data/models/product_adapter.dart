import 'package:hive/hive.dart';
import 'package:product_management_getx/data/models/product.dart';

class ProductAdapter extends TypeAdapter<Product> {
  @override
  final int typeId = 1;

  @override
  Product read(BinaryReader reader) {
    return Product(
      id: reader.readInt(),
      name: reader.readString(),
      price: reader.readInt(),
      quantity: reader.readInt(),
      cover: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, Product obj) {
    writer.writeInt(obj.id);
    writer.writeString(obj.name);
    writer.writeInt(obj.price);
    writer.writeInt(obj.quantity);
    writer.writeString(obj.cover);
  }
}
