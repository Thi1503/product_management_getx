import 'package:hive/hive.dart';
import 'package:product_management_getx/data/models/user.dart';

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 0;

  @override
  User read(BinaryReader reader) {
    return User(
      taxCode: reader.readInt(),
      username: reader.readString(),
      accessToken: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer.writeInt(obj.taxCode);
    writer.writeString(obj.username);
    writer.writeString(obj.accessToken);
  }
}
