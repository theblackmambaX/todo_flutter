import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6B4EE8),
          primary: const Color(0xFF6B4EE8),
          secondary: const Color(0xFF8E77ED),
          surface: Colors.white,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const TodoListScreen(),
    );
  }
}

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final List<Todo> _todos = [];
  final TextEditingController _textController = TextEditingController();
  bool _isComposing = false;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _addTodo(String text) {
    if (text.isEmpty) return;
    setState(() {
      _todos.add(Todo(
        id: DateTime.now().toString(),
        text: text,
        completed: false,
      ));
      _textController.clear();
      _isComposing = false;
    });
  }

  void _toggleTodo(String id) {
    setState(() {
      final todo = _todos.firstWhere((todo) => todo.id == id);
      todo.completed = !todo.completed;
    });
  }

  void _deleteTodo(String id) {
    setState(() {
      _todos.removeWhere((todo) => todo.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120.0,
            floating: true,
            pinned: true,
            elevation: 0,
            backgroundColor: theme.colorScheme.surface,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'My Tasks',
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: false,
              titlePadding: const EdgeInsets.only(left: 16.0, bottom: 16.0),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: theme.colorScheme.outline.withOpacity(0.1),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.add_circle_outline,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          controller: _textController,
                          decoration: const InputDecoration(
                            hintText: 'Add a task',
                            border: InputBorder.none,
                            hintStyle: TextStyle(fontSize: 16),
                          ),
                          style: const TextStyle(fontSize: 16),
                          onChanged: (text) {
                            setState(() {
                              _isComposing = text.isNotEmpty;
                            });
                          },
                          onSubmitted: _addTodo,
                        ),
                      ),
                      if (_isComposing)
                        IconButton(
                          icon: Icon(
                            Icons.arrow_forward_ios,
                            color: theme.colorScheme.primary,
                            size: 20,
                          ),
                          onPressed: () => _addTodo(_textController.text),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final todo = _todos[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: theme.colorScheme.outline.withOpacity(0.1),
                      ),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      leading: IconButton(
                        icon: Icon(
                          todo.completed ? Icons.check_circle : Icons.circle_outlined,
                          color: todo.completed ? theme.colorScheme.primary : theme.colorScheme.outline,
                        ),
                        onPressed: () => _toggleTodo(todo.id),
                      ),
                      title: Text(
                        todo.text,
                        style: TextStyle(
                          decoration: todo.completed ? TextDecoration.lineThrough : null,
                          color: todo.completed ? theme.colorScheme.outline : theme.colorScheme.onSurface,
                          fontSize: 16,
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.delete_outline,
                          color: theme.colorScheme.error,
                        ),
                        onPressed: () => _deleteTodo(todo.id),
                      ),
                    ),
                  ),
                );
              },
              childCount: _todos.length,
            ),
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 80)),
        ],
      ),
    );
  }
}

class Todo {
  String id;
  String text;
  bool completed;

  Todo({
    required this.id,
    required this.text,
    required this.completed,
  });
}
