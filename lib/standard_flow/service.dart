mixin CreateStandardService<T, Create> {
  Future<Create> getCreate();
  Future<T> create(Create create);
}

mixin UpdateStandardService<T, Get, Update> {
  Future<Update> getUpdate(Get request);
  Future<T> update(Update update);
}

mixin GetStandardService<T, Get> {
  Future<T> get(Get uid);
}

mixin ListStandardService<T> {
  Stream<T> list(); //Needs a param?
}

/// T -> Model
/// Get -> type of get param
/// Update -> type of update param
/// Create -> type of create param
abstract class StandardService<T, Create, Get, Update>
    with
        CreateStandardService<T, Create>,
        UpdateStandardService<T, Get, Update>,
        GetStandardService<T, Get>,
        ListStandardService<T> {}
