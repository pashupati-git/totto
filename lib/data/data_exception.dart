
class DataException implements Exception
{
    final String message;

    const DataException(this.message);

    @override
    String toString() => 'DataException: $message';
}
