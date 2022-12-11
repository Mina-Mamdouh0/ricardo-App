abstract class RicardoState {}

class InitialState extends RicardoState{}

class LoadingGetUser extends RicardoState{}
class SuccessGetUser extends RicardoState{}
class ErrorGetUser extends RicardoState{
  final String error;
  ErrorGetUser(this.error);
}
class LoadingGetProducts extends RicardoState{}
class SuccessGetProducts extends RicardoState{}
class ErrorGetProducts extends RicardoState{
  final String error;
  ErrorGetProducts(this.error);
}


class LoadingImagesProduct extends RicardoState{}
class SuccessImagesProduct extends RicardoState{}

class SignOutState extends RicardoState{}
class CurrentIndexAdd extends RicardoState{}
class CurrentIndexDetails extends RicardoState{}
class PickedImagesProduct extends RicardoState{}
class RemoveImagesProduct extends RicardoState{}
class GetMyProduct extends RicardoState{}
class GetSearchProduct extends RicardoState{}

class LoadingUpdateProduct extends RicardoState{}
class SuccessUpdateProduct extends RicardoState{}
class ErrorUpdateProduct extends RicardoState{
  final String error;
  ErrorUpdateProduct(this.error);
}






