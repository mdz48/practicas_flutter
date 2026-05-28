// void main() {
//   // 1. Crea un Map<String, String> con 5 pares nombre-telefono
//   Map<String, String> agenda = {
//     'Juan': '555-0199',
//     'María': '555-0142',
//     'Pedro': '555-0188',
//     'Ana': '555-0177',
//     'Luis': '555-0166',
//   };

//   print('--- Lista de Contactos ---');
//   agenda.forEach((nombre, telefono) {
//     print('Nombre: $nombre, Teléfono: $telefono');
//   });
//   print('--------------------------\n');

//   String nombreABuscar = 'María';
//   print('Buscando a: $nombreABuscar');
//   if (agenda.containsKey(nombreABuscar)) {
//     print('Teléfono de $nombreABuscar: ${agenda[nombreABuscar]}');
//   } else {
//     print('Contacto "$nombreABuscar" no encontrado.');
//   }

//   String nombreInexistente = 'Carlos';
//   print('\nBuscando a: $nombreInexistente');
//   if (agenda.containsKey(nombreInexistente)) {
//     print('Teléfono de $nombreInexistente: ${agenda[nombreInexistente]}');
//   } else {
//     print('Contacto "$nombreInexistente" no encontrado.');
//   }
// }