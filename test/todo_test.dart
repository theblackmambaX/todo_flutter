import 'package:flutter_test/flutter_test.dart';
import 'package:todo_flutter/main.dart';

void main() {
  group('TodoModel Tests', () {
    late TodoModel todoModel;

    setUp(() {
      todoModel = TodoModel();
    });

    test('should add todo', () {
      todoModel.addTodo('Test Task');
      expect(todoModel.todos.length, 1);
      expect(todoModel.todos.first.text, 'Test Task');
      expect(todoModel.todos.first.completed, false);
    });

    test('should toggle todo', () {
      todoModel.addTodo('Test Task');
      todoModel.toggleTodo(0);
      expect(todoModel.todos.first.completed, true);
      todoModel.toggleTodo(0);
      expect(todoModel.todos.first.completed, false);
    });

    test('should remove todo', () {
      todoModel.addTodo('Test Task');
      expect(todoModel.todos.length, 1);
      todoModel.removeTodo(0);
      expect(todoModel.todos.length, 0);
    });

    test('should handle invalid indices', () {
      todoModel.addTodo('Test Task');
      todoModel.toggleTodo(1); // Invalid index
      expect(todoModel.todos.first.completed, false);
      todoModel.removeTodo(1); // Invalid index
      expect(todoModel.todos.length, 1);
    });
  });

  group('Todo Class Tests', () {
    test('should create todo with default values', () {
      final todo = Todo(text: 'Test');
      expect(todo.text, 'Test');
      expect(todo.completed, false);
    });

    test('should create completed todo', () {
      final todo = Todo(text: 'Test', completed: true);
      expect(todo.completed, true);
    });

    test('should copy with new values', () {
      final todo = Todo(text: 'Test');
      final copied = todo.copyWith(completed: true);
      expect(copied.text, 'Test');
      expect(copied.completed, true);
    });
  });
}
