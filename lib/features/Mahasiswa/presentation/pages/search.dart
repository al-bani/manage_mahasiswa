import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:manage_mahasiswa/features/Auth/presentation/widgets/components.dart';

void main() {
  runApp(const SearchScreen());
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  static const _prefsKey = 'search_history';
  final TextEditingController _searchController = TextEditingController();
  List<String> _history = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _history = prefs.getStringList(_prefsKey) ?? [];
      _loading = false;
    });
  }

  Future<void> _saveQuery(String query) async {
    if (query.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_prefsKey) ?? [];

    // dedupe: pindahkan ke depan
    list.remove(query);
    list.insert(0, query);

    // batasi max 10
    if (list.length > 10) {
      list.removeRange(10, list.length);
    }

    await prefs.setStringList(_prefsKey, list);
    setState(() => _history = list);
  }

  Future<void> _removeAt(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final list = List<String>.from(_history);
    list.removeAt(index);
    await prefs.setStringList(_prefsKey, list);
    setState(() => _history = list);
  }

  Future<void> _clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefsKey);
    setState(() => _history = []);
  }

  void _goSearch(String query) async {
    final q = query.trim();
    if (q.isEmpty) return;
    await _saveQuery(q);
    GoRouter.of(context).goNamed('home', extra: q);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: _appBody(context),
    );
  }

  Widget _appBody(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => GoRouter.of(context).goNamed('home'),
                icon: const Icon(Icons.arrow_back),
              ),
              Expanded(
                child:
                    NormalFiled(text: "Search", controller: _searchController),
              ),
              IconButton(
                onPressed: () => _goSearch(_searchController.text),
                icon: const Icon(Icons.search),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Text(
                'Riwayat Pencarian',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              if (_history.isNotEmpty)
                TextButton.icon(
                  onPressed: _clearAll,
                  icon: const Icon(Icons.delete_sweep_outlined),
                  label: const Text('Clear all'),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(child: _historyList()),
        ],
      ),
    );
  }

  Widget _historyList() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_history.isEmpty) {
      return const Center(child: Text('Belum ada riwayat pencarian'));
    }

    return ListView.separated(
      itemCount: _history.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final item = _history[index];
        return ListTile(
          leading: const Icon(Icons.history),
          title: Text(item),
          onTap: () => _goSearch(item),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                tooltip: 'Cari lagi',
                icon: const Icon(Icons.search),
                onPressed: () => _goSearch(item),
              ),
              IconButton(
                tooltip: 'Hapus',
                icon: const Icon(Icons.close),
                onPressed: () => _removeAt(index),
              ),
            ],
          ),
        );
      },
    );
  }
}
