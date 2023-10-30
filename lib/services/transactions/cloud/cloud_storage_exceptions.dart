class CloudStorageException implements Exception {
  const CloudStorageException();
}

// C in CRUD
class CouldNotCreateTransactionsException extends CloudStorageException {}

// R in CRUD
class CouldNotGetAllTransactionsException extends CloudStorageException {}

// U in CRUD
class CouldNotUpdateTransactionsException extends CloudStorageException {}

// D in CRUD
class CouldNotDeleteTransactionsException extends CloudStorageException {}
