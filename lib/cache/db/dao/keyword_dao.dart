import 'package:flutter_extension/cache/db/manager/db_provider.dart';

class KeywordDao extends DBProvider {
  @override
  createTableName() => kTable;

  @override
  createTableColumn() => '''
    $kId INTEGER PRIMARY KEY AUTOINCREMENT, 
    $kName TEXT
  ''';

  // 插入一条数据
  Future<Keyword> insert(Keyword keyword) async {
    var db = await getDatabase();
    keyword.id = await db.insert(kTable, keyword.toMap());
    return keyword;
  }

  // 根据ID查找信息
  Future<Keyword> query(int id) async {
    var db = await getDatabase();
    List<Map> maps = await db.query(
      kTable,
      columns: [kId, kName],
      where: '$kId = ?',
      whereArgs: [id],
    );
    if (maps.length > 0) return Keyword.fromMap(maps.first);
    return null;
  }

  // 根据keyword查找信息
  Future<bool> queryKeyword(String keyword) async {
    var db = await getDatabase();
    List<Map> maps = await db.query(kTable,
        columns: [kId, kName], where: '$kName = ?', whereArgs: [keyword]);
    return maps.length > 0;
  }

  // 查找所有数据
  Future<List<Keyword>> queryAll() async {
    var db = await getDatabase();
    List<Map> maps = await db.query(
      kTable,
      columns: [kId, kName],
      orderBy: kId + " DESC",
    );
    if (maps == null || maps.length == 0) return [];

    List<Keyword> hkList = [];
    for (int i = 0; i < maps.length; i++) {
      if (i < 10)
        hkList.add(Keyword.fromMap(maps[i]));
      else
        delete(Keyword.fromMap(maps[i]).id);
    }
    return hkList;
  }

  // 根据ID删除信息
  Future<int> delete(int id) async {
    var db = await getDatabase();
    return await db.delete(
      kTable,
      where: '$kId = ?',
      whereArgs: [id],
    );
  }

  // 删除所有信息
  Future<int> deleteAll() async {
    var db = await getDatabase();
    return await db.rawDelete("DELETE FROM $kTable");
  }

  // 更新信息
  Future<int> update(Keyword hk) async {
    var db = await getDatabase();
    return await db.update(
      kTable,
      hk.toMap(),
      where: '$kId = ?',
      whereArgs: [hk.id],
    );
  }
}

/// 数据库表的表名和字段建议单独写出来，方便上面根据字段查询和更新时直接使用，以及全局修改
final String kTable = "Keyword";
final String kId = "id";
final String kName = "name";

/// 数据库表对应的model对象
class Keyword {
  int id;
  String name;

  Keyword(this.name);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      kName: name,
    };
    if (id != null) map[kId] = id;
    return map;
  }

  Keyword.fromMap(Map<String, dynamic> map) {
    id = map[kId];
    name = map[kName];
  }
}
