# **Datum - Object-relational mapping in Rails**

Use Datum to connect database tables to their perspective classes. The library is provide within a base class that require zero-configuration. The many methods allows for mapping between classes and existing tables and the  recalling of data between different table through associations.

## **Features and Examples**

- Have new class inherit from base class to allow access to methods
```
class TableClass < Datum
end
```

- Associations are implement through class methods
```
class Child < Datum
  has_many :items,
    class_name: "Item",
    foreign_key: :owner_id
end
```
or
```
class Child < ApplicationRecord
  belongs_to :parent,
    class_name: "Parent",
    foreign_key: :child_id
extend
```
or
```
class Parent < ApplicationRecord
  has_many: items,
    through: :childs
end
```
if class_name, foreign_key, and primary_key are not given, association will be automated base on the names of the classes.

### **Some Available Methods**

- `.all` fetch all rows in a table and return it as a Datum object.
- `.find` takes an id(integer) as an argument and find the first row in tables that matches that id.
- `.save` if object already exist in the table, update it with the current params, else add it to the table.
- `.where` take in an params hash and use it to find all the rows in the table that matches those params.
