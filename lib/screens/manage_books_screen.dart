// lib/screens/manage_books_screen.dart

import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/book_service.dart';
import '../theme/app_colors.dart';

class ManageBooksScreen extends StatefulWidget {
  const ManageBooksScreen({Key? key}) : super(key: key);

  @override
  _ManageBooksScreenState createState() => _ManageBooksScreenState();
}

class _ManageBooksScreenState extends State<ManageBooksScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Add-Book form controllers
  final _addTitleCtrl     = TextEditingController();
  final _addAuthorCtrl    = TextEditingController();
  final _addPointsCtrl    = TextEditingController(text: '10');
  final _addWordCountCtrl = TextEditingController();
  final _addGenreCtrl     = TextEditingController();

  // —— New: static list of readers for the dropdown
  final List<String> _readers = const [
    'Londyn',
    'Aubri',
    'Heidi',
    'Mindi',
    'Kinzli',
  ];
  String? _selectedReader;           // ← which reader is picked
  String? _selectedBookTitle;        // ← which book is picked

  // For book dropdown
  late Future<List<Book>> _booksFuture;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _booksFuture   = fetchBooks();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _addTitleCtrl.dispose();
    _addAuthorCtrl.dispose();
    _addPointsCtrl.dispose();
    _addWordCountCtrl.dispose();
    _addGenreCtrl.dispose();
    super.dispose();
  }

  Future<void> _submitAddBook() async {
    try {
      await addBook(
        title:      _addTitleCtrl.text,
        author:     _addAuthorCtrl.text.isEmpty ? null : _addAuthorCtrl.text,
        pointValue: int.parse(_addPointsCtrl.text),
        wordCount:  int.parse(_addWordCountCtrl.text),
        genre:      _addGenreCtrl.text.isEmpty ? null : _addGenreCtrl.text,
      );
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Book added!')));
      // Clear & refresh
      _addTitleCtrl.clear();
      _addAuthorCtrl.clear();
      _addPointsCtrl.text = '10';
      _addWordCountCtrl.clear();
      _addGenreCtrl.clear();
      setState(() => _booksFuture = fetchBooks());
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _submitAssignBook() async {
    if (_selectedReader == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Pick a reader first')));
      return;
    }
    if (_selectedBookTitle == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Pick a book first')));
      return;
    }
    try {
      await assignBook(
        readerName: _selectedReader!,
        bookTitle:  _selectedBookTitle!,
      );
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Book assigned!')));
      // reset only the reader and book selections if you want
      setState(() {
        _selectedReader = null;
        _selectedBookTitle = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Books'),
        backgroundColor: AppColors.primaryPeach,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Add Book'),
            Tab(text: 'Assign Book'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // —— Add Book Form ——
          Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                TextField(
                  controller: _addTitleCtrl,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: _addAuthorCtrl,
                  decoration: const InputDecoration(labelText: 'Author'),
                ),
                TextField(
                  controller: _addPointsCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Point Value'),
                ),
                TextField(
                  controller: _addWordCountCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Word Count'),
                ),
                TextField(
                  controller: _addGenreCtrl,
                  decoration: const InputDecoration(labelText: 'Genre'),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _submitAddBook,
                    child: const Text('Add Book'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryPeach,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // —— Assign Book Form ——
          Padding(
            padding: const EdgeInsets.all(16),
            child: FutureBuilder<List<Book>>(
              future: _booksFuture,
              builder: (ctx, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snap.hasError) {
                  return Center(child: Text('Error: ${snap.error}'));
                }
                final books = snap.data!;

                return ListView(
                  children: [
                    // ← Reader dropdown
                    DropdownButtonFormField<String>(
                      decoration:
                      const InputDecoration(labelText: 'Select Reader'),
                      items: _readers
                          .map((name) => DropdownMenuItem(
                        value: name,
                        child: Text(name),
                      ))
                          .toList(),
                      onChanged: (v) => setState(() => _selectedReader = v),
                      value: _selectedReader,
                    ),

                    const SizedBox(height: 16),

                    // ← Book dropdown
                    DropdownButtonFormField<String>(
                      decoration:
                      const InputDecoration(labelText: 'Select Book'),
                      items: books
                          .map((b) => DropdownMenuItem(
                        value: b.title,
                        child: Text(b.title),
                      ))
                          .toList(),
                      onChanged: (v) =>
                          setState(() => _selectedBookTitle = v),
                      value: _selectedBookTitle,
                    ),

                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _submitAssignBook,
                        child: const Text('Assign Book'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryPeach,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
