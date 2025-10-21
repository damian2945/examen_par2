import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mi Aplicación',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Variables fijas para comparación
  final String miUser = 'gilberto';
  final String miContra = '123456';

  // Controladores para los TextFields
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Variables para validación
  String _userError = '';
  String _passwordError = '';

  @override
  void dispose() {
    _userController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    setState(() {
      _userError = _userController.text.isEmpty ? 'El usuario es requerido' : '';
      _passwordError =
          _passwordController.text.isEmpty ? 'La contraseña es requerida' : '';
    });

    if (_userError.isEmpty && _passwordError.isEmpty) {
      if (_userController.text == miUser &&
          _passwordController.text == miContra) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const PostsListPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Usuario o contraseña incorrectos'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio de Sesión'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                TextField(
                  controller: _userController,
                  decoration: InputDecoration(
                    labelText: 'Usuario',
                    hintText: 'Ingrese su usuario',
                    border: OutlineInputBorder(),
                    errorText: _userError.isEmpty ? null : _userError,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    hintText: 'Ingrese su contraseña',
                    border: OutlineInputBorder(),
                    errorText: _passwordError.isEmpty ? null : _passwordError,
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _login,
                  child: const Text('Ingresar'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PostsListPage extends StatefulWidget {
  const PostsListPage({Key? key}) : super(key: key);

  @override
  State<PostsListPage> createState() => _PostsListPageState();
}

class _PostsListPageState extends State<PostsListPage> {
  int _selectedIndex = 0;

  // Lista de posts precargados
  List<Post> posts = [
    Post(
      id: 1,
      title: 'Mi primer post',
      content: 'Este es el contenido del primer post en la aplicación.',
      author: 'Usuario 1',
    ),
    Post(
      id: 2,
      title: 'Flutter es increíble',
      content: 'Desarrollo de aplicaciones móviles con Flutter es muy eficiente.',
      author: 'Usuario 2',
    ),
    Post(
      id: 3,
      title: 'Tips de programación',
      content: 'Algunos tips para mejorar tu código y hacerlo más limpio.',
      author: 'Usuario 3',
    ),
    Post(
      id: 4,
      title: 'Nuevo proyecto',
      content: 'Iniciando un nuevo proyecto emocionante con tecnología moderna.',
      author: 'Usuario 4',
    ),
  ];

  void _addPost() {
    showDialog(
      context: context,
      builder: (context) {
        String title = '';
        String content = '';
        return AlertDialog(
          title: const Text('Agregar nuevo Post'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Título'),
                onChanged: (value) => title = value,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Contenido'),
                onChanged: (value) => content = value,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                if (title.isNotEmpty && content.isNotEmpty) {
                  setState(() {
                    posts.add(Post(
                      id: posts.length + 1,
                      title: title,
                      content: content,
                      author: 'Usuario Actual',
                    ));
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Agregar'),
            ),
          ],
        );
      },
    );
  }

  void _logout() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Listado de Posts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Salir',
          ),
        ],
      ),
      body: _selectedIndex == 0
          ? ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          posts[index].title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          posts[index].content,
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Por: ${posts[index].author}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          : Center(
              child: Text(
                'Sección de Usuarios',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addPost,
        tooltip: 'Agregar Post',
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.description),
            label: 'Posts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Usuarios',
          ),
        ],
      ),
    );
  }
}

class Post {
  final int id;
  final String title;
  final String content;
  final String author;

  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.author,
  });
}