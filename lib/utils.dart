Type typeOf<T>() => T;

typedef void ActionOf1<T>(T t);
typedef void ActionOf2<T1, T2>(T1 t1, T2 t2);
typedef void ActionOf3<T1, T2, T3>(T1 t1, T2 t2, T3 t3);

typedef bool Predicate();
typedef bool Predicate1<T>(T t);
typedef bool Predicate2<T1, T2>(T1 t1, T2 t2);
typedef bool Predicate3<T1, T2, T3>(T1 t1, T2 t2, T3 t3);

typedef R FunctionOf<R>();
typedef R FunctionOf1<T, R>(T t);
typedef R FunctionOf2<T1, T2, R>(T1 t1, T2 t2);
typedef R FunctionOf3<T1, T2, T3, R>(T1 t1, T2 t2, T3 t3);

//To be able to pass a primitive type as reference to a function
class PrimitiveWrapper<T> {
  T value;
  PrimitiveWrapper(this.value);
}
