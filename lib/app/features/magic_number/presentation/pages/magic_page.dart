import 'package:flutter/material.dart';
import 'package:noveno/app/features/magic_number/presentation/provider/magic_provider.dart';
import 'package:provider/provider.dart';

class MagicPage extends StatefulWidget {
  const MagicPage({super.key});

  @override
  State<MagicPage> createState() => _MagicPageState();
}

class _MagicPageState extends State<MagicPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MagicProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Busqueda Binaria'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Ingresa un numero entre 1 y 100',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              enabled: provider.canSearch,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Numero objetivo',
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: provider.canSearch
                  ? () {
                      final value = int.tryParse(_controller.text);
                      if (value != null) {
                        context.read<MagicProvider>().startSearch(value);
                      }
                    }
                  : null,
              child: const Text('Iniciar busqueda'),
            ),
            const SizedBox(height: 24),
            _buildStatus(provider),
            const SizedBox(height: 16),
            if (provider.guessHistory.isNotEmpty) _buildHistory(provider),
            const SizedBox(height: 16),
            if (!provider.canSearch)
              ElevatedButton(
                onPressed: () {
                  _controller.clear();
                  context.read<MagicProvider>().reset();
                },
                child: const Text('Reiniciar'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatus(MagicProvider provider) {
    switch (provider.state) {
      case MagicState.initial:
        return const Text('Esperando numero...');
      case MagicState.searching:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Intento ${provider.attempts} / 7'),
            Text('Adivinando: ${provider.currentGuess}'),
          ],
        );
      case MagicState.found:
        return Text(
          'Encontrado: ${provider.targetNumber} en ${provider.attempts} intentos',
          style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
        );
      case MagicState.notFound:
        return const Text(
          'No encontrado en 7 intentos',
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        );
    }
  }

  Widget _buildHistory(MagicProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Historial de intentos:', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: provider.guessHistory
              .asMap()
              .entries
              .map((e) => Chip(label: Text('#${e.key + 1}: ${e.value}')))
              .toList(),
        ),
      ],
    );
  }
}