class ApiResponse<T> {
  ApiResponse.loading(this.message) : status = Status.LOADING;
  ApiResponse.completed(this.data) : status = Status.COMPLETED;
  ApiResponse.error(this.message, {this.code}) : status = Status.ERROR;

  Status status;
  T? data;
  String? message;
  String? code;

  @override
  String toString() {
    return 'Status : $status \n Message : $message \n Data : $data';
  }
}

// ignore: constant_identifier_names
enum Status { LOADING, COMPLETED, ERROR }
