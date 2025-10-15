class Result {
  Result.failure(this.error) : isSuccess = false;
  Result.success() : isSuccess = true, error = null;
  
  final bool isSuccess;
  final String? error;
}
