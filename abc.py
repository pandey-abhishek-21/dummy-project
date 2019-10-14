import json
with open('person.json') as f:
  data = json.load(f)
# Output: {'name': 'Bob', 'languages': ['English', 'Fench']}
print(data)
print(data["name"])