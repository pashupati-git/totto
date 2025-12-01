import '../../../data/models/group_model.dart';
import '../../../data/models/product_model.dart';
import '../../../data/models/user_profile_model.dart';

abstract class SearchResultItem
{
}

class ProductSearchResult extends SearchResultItem
{
    final Product product;
    ProductSearchResult(this.product);
}

class GroupSearchResult extends SearchResultItem
{
    final Group group;
    final bool isJoined;

    GroupSearchResult(this.group, {required this.isJoined});
}

class UserSearchResult extends SearchResultItem
{
    final UserProfile user;
    UserSearchResult(this.user);
}
