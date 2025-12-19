import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChecklistPage(),
    );
  }
}

enum TaskStatus { done, notDone }

class ChecklistPage extends StatefulWidget {
  const ChecklistPage({super.key});

  @override
  State<ChecklistPage> createState() => _ChecklistPageState();
}

class _ChecklistPageState extends State<ChecklistPage> {
  List<String> tasks = [];
  List<TaskStatus> status = [];

  void addTask(String task) {
    setState(() {
      tasks.add(task);
      status.add(TaskStatus.notDone);
    });
  }

  void deleteTask(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirm Delete"),
          content: const Text("Are you sure you want to delete this task?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  tasks.removeAt(index);
                  status.removeAt(index);
                });
                Navigator.pop(context);
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  void clearAll() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirm Clear All"),
          content: const Text("Delete all tasks?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  tasks.clear();
                  status.clear();
                });
                Navigator.pop(context);
              },
              child: const Text("Clear"),
            ),
          ],
        );
      },
    );
  }

  void editTask(int index) {
    String edited = tasks[index];
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Task"),
          content: TextField(
            controller: TextEditingController(text: edited),
            onChanged: (value) => edited = value,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (edited.isNotEmpty) {
                  setState(() {
                    tasks[index] = edited;
                  });
                }
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    int doneCount =
        status.where((element) => element == TaskStatus.done).length;

    List<int> indices = List.generate(tasks.length, (i) => i);
    indices.sort((a, b) {
      if (status[a] == status[b]) return 0;
      if (status[a] == TaskStatus.notDone) return -1;
      return 1;
    });

    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text(
          "Checklist",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep, color: Colors.white),
            onPressed: clearAll,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              "Tasks: ${tasks.length} | Done: $doneCount",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: indices.length,
              itemBuilder: (context, i) {
                int index = indices[i];
                bool isDone = status[index] == TaskStatus.done;

                return Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isDone ? Colors.green[50] : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      )
                    ],
                  ),
                  child: ListTile(
                    leading: Checkbox(
                      value: isDone,
                      onChanged: (value) {
                        setState(() {
                          status[index] =
                              value! ? TaskStatus.done : TaskStatus.notDone;
                        });
                      },
                    ),
                    title: Text(
                      tasks[index],
                      style: TextStyle(
                        decoration: isDone ? TextDecoration.lineThrough : null,
                        color: isDone ? Colors.grey : Colors.black,
                        fontStyle: isDone ? FontStyle.italic : FontStyle.normal,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon:
                              const Icon(Icons.edit, color: Colors.blueAccent),
                          onPressed: () => editTask(index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => deleteTask(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          String newTask = "";
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Add Task"),
                content: TextField(
                  onChanged: (value) => newTask = value,
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (newTask.isNotEmpty) {
                        addTask(newTask);
                      }
                      Navigator.pop(context);
                    },
                    child: const Text("Add"),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
