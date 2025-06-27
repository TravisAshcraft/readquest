import 'package:flutter/material.dart';
import '../models/child.dart';
import '../widgets/child_card.dart';
import 'childdetail_screen.dart';

class ParentDashboardScreen extends StatefulWidget {
  final String parentName;
  final List<Child> children;

  const ParentDashboardScreen({
    Key? key,
    required this.parentName,
    required this.children,
  }) : super(key: key);

  @override
  _ParentDashboardScreenState createState() => _ParentDashboardScreenState();
}

class _ParentDashboardScreenState extends State<ParentDashboardScreen> {
  late List<Child> _children;

  @override
  void initState() {
    super.initState();
    // initialize from what was passed in
    _children = List.from(widget.children);
  }

  void _addChild() {
    final nameCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add New Child'),
        content: TextField(
          controller: nameCtrl,
          decoration: const InputDecoration(labelText: 'Child Name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final name = nameCtrl.text.trim();
              if (name.isEmpty) return;
              final newChild = Child(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                name: name,
                pairingCode: '',
              );
              setState(() => _children.add(newChild));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Added ${newChild.name}')),
              );
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hello, ${widget.parentName}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add Child',
            onPressed: _addChild,
          ),
        ],
      ),
      body: _children.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.sentiment_dissatisfied, size: 64, color: Colors.grey),
            SizedBox(height: 12),
            Text('No children yet', style: TextStyle(fontSize: 18, color: Colors.grey)),
          ],
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: _children.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.9,
          ),
          itemBuilder: (_, i) => ChildCard(
            child: _children[i],
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ChildDetailsScreen(child: _children[i]),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addChild,
        icon: const Icon(Icons.person_add),
        label: const Text('Add Child'),
      ),
    );
  }
}