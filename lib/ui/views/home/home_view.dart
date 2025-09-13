import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'home_viewmodel.dart';
import '../../../models/todo.dart';

class HomeView extends StackedView<HomeViewModel> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    HomeViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, viewModel),
            Expanded(
              child: PageView(
                controller: viewModel.pageController,
                onPageChanged: viewModel.onPageChanged,
                children: [
                  _buildDashboard(context, viewModel),
                  _buildNotesTab(context, viewModel),
                  _buildTodosTab(context, viewModel),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context, viewModel),
      floatingActionButton: _buildFAB(context, viewModel),
    );
  }

  Widget _buildHeader(BuildContext context, HomeViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.secondary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Good ${_getTimeOfDay()},',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                ),
          ),
          Text(
            'Stay organized',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }

  String _getTimeOfDay() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Morning';
    if (hour < 17) return 'Afternoon';
    return 'Evening';
  }

  Widget _buildDashboard(BuildContext context, HomeViewModel viewModel) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildQuickStats(context, viewModel),
          const SizedBox(height: 24),
          _buildRecentNotes(context, viewModel),
          const SizedBox(height: 24),
          _buildTodayTodos(context, viewModel),
        ],
      ),
    );
  }

  Widget _buildQuickStats(BuildContext context, HomeViewModel viewModel) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            context,
            'Notes',
            '${viewModel.notesCount}',
            Icons.note_alt_outlined,
            Colors.blue,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            context,
            'Active Todos',
            '${viewModel.activeTodosCount}',
            Icons.task_alt,
            Colors.green,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String count,
    IconData icon,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              count,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentNotes(BuildContext context, HomeViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Notes',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            TextButton(
              onPressed: () => viewModel.switchToTab(1),
              child: const Text('See all'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (viewModel.recentNotes.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.note_add_outlined,
                      size: 48,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'No notes yet',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tap the + button to create your first note',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey.shade500,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          )
        else
          ...viewModel.recentNotes.map((note) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.note),
                  ),
                  title: Text(
                    note.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    note.content,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () => viewModel.editNote(note),
                ),
              )),
      ],
    );
  }

  Widget _buildTodayTodos(BuildContext context, HomeViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Today\'s Tasks',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            TextButton(
              onPressed: () => viewModel.switchToTab(2),
              child: const Text('See all'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (viewModel.todayTodos.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.task_alt,
                      size: 48,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'No tasks for today',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          )
        else
          ...viewModel.todayTodos.map((todo) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: Checkbox(
                    value: todo.isCompleted,
                    onChanged: (_) => viewModel.toggleTodo(todo.id),
                  ),
                  title: Text(
                    todo.title,
                    style: TextStyle(
                      decoration: todo.isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  subtitle: todo.description.isNotEmpty
                      ? Text(todo.description)
                      : null,
                  trailing: _buildPriorityIndicator(todo.priority),
                  onTap: () => viewModel.editTodo(todo),
                ),
              )),
      ],
    );
  }

  Widget _buildNotesTab(BuildContext context, HomeViewModel viewModel) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: viewModel.searchController,
            decoration: const InputDecoration(
              hintText: 'Search notes...',
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: viewModel.onSearchChanged,
          ),
        ),
        Expanded(
          child: viewModel.filteredNotes.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.note_outlined,
                        size: 64,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        viewModel.searchQuery.isEmpty
                            ? 'No notes yet'
                            : 'No notes found',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Colors.grey.shade600,
                            ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: viewModel.filteredNotes.length,
                  itemBuilder: (context, index) {
                    final note = viewModel.filteredNotes[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor:
                              Theme.of(context).colorScheme.primaryContainer,
                          child: Icon(
                            Icons.note,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        title: Text(
                          note.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        subtitle: Text(
                          note.content,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: PopupMenuButton(
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              onTap: () => Future.delayed(
                                const Duration(milliseconds: 100),
                                () => viewModel.editNote(note),
                              ),
                              child: const Row(
                                children: [
                                  Icon(Icons.edit),
                                  SizedBox(width: 8),
                                  Text('Edit'),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              onTap: () => Future.delayed(
                                const Duration(milliseconds: 100),
                                () => viewModel.deleteNote(note.id),
                              ),
                              child: const Row(
                                children: [
                                  Icon(Icons.delete, color: Colors.red),
                                  SizedBox(width: 8),
                                  Text('Delete'),
                                ],
                              ),
                            ),
                          ],
                        ),
                        onTap: () => viewModel.editNote(note),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildTodosTab(BuildContext context, HomeViewModel viewModel) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(text: 'Active'),
              Tab(text: 'Completed'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildTodosList(context, viewModel, viewModel.activeTodos),
                _buildTodosList(context, viewModel, viewModel.completedTodos),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTodosList(
    BuildContext context,
    HomeViewModel viewModel,
    List todos,
  ) {
    if (todos.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.task_outlined,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'No todos yet',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey.shade600,
                  ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: todos.length,
      itemBuilder: (context, index) {
        final todo = todos[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: Checkbox(
              value: todo.isCompleted,
              onChanged: (_) => viewModel.toggleTodo(todo.id),
            ),
            title: Text(
              todo.title,
              style: TextStyle(
                decoration: todo.isCompleted
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: todo.description.isNotEmpty
                ? Text(todo.description)
                : null,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildPriorityIndicator(todo.priority),
                const SizedBox(width: 8),
                PopupMenuButton(
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      onTap: () => Future.delayed(
                        const Duration(milliseconds: 100),
                        () => viewModel.editTodo(todo),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.edit),
                          SizedBox(width: 8),
                          Text('Edit'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      onTap: () => Future.delayed(
                        const Duration(milliseconds: 100),
                        () => viewModel.deleteTodo(todo.id),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.delete, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Delete'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            onTap: () => viewModel.editTodo(todo),
          ),
        );
      },
    );
  }

  Widget _buildPriorityIndicator(TodoPriority priority) {
    Color color;
    switch (priority) {
      case TodoPriority.high:
        color = Colors.red;
        break;
      case TodoPriority.medium:
        color = Colors.orange;
        break;
      case TodoPriority.low:
        color = Colors.green;
        break;
    }

    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context, HomeViewModel viewModel) {
    return BottomNavigationBar(
      currentIndex: viewModel.currentIndex,
      onTap: viewModel.switchToTab,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.note),
          label: 'Notes',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.task),
          label: 'Todos',
        ),
      ],
    );
  }

  Widget _buildFAB(BuildContext context, HomeViewModel viewModel) {
    return FloatingActionButton.extended(
      onPressed: () => viewModel.showAddDialog(context),
      icon: const Icon(Icons.add),
      label: Text(
        viewModel.currentIndex == 0 
            ? 'Add New'
            : viewModel.currentIndex == 1 
                ? 'Add Note' 
                : 'Add Todo'
      ),
    );
  }

  @override
  HomeViewModel viewModelBuilder(BuildContext context) => HomeViewModel();
}