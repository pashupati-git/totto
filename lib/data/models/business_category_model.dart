
class BusinessCategory
{
    final int id;
    final String name;

    const BusinessCategory({
        required this.id,
        required this.name,

    });

    factory BusinessCategory.fromJson(Map<String, dynamic> json)
    {
        return BusinessCategory(
            id: json['id'] as int? ?? 0,
            name: json['name'] as String? ?? 'Unnamed Category',
        );
    }
}



