import 'dart:async';

import 'package:book_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

import 'enums/enums.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final keyApplicationId = 'FsSoI0fFQdMTYCFWoQd7phWhfxwK1N2YSZThctvz';
  final keyClientKey = 'AhRV2xBg8f5AejeKQKH8gnffO1Pdnr4nraG6WP00';
  final keyParseServerUrl = 'https://parseapi.back4app.com';

  await Parse().initialize(keyApplicationId, keyParseServerUrl,
      clientKey: keyClientKey, debug: true);

  runApp(MaterialApp(
    home: HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('GenZ bookApp'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              const Center(
                child: Text('Easily store your books here',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(
                height: 16,
              ),
              Container(
                height: 50,
                width: double.infinity,
                child: TextButton(
                  style: TextButton.styleFrom(
                      primary: Colors.white, backgroundColor: Colors.blue),
                  child: const Text('Add Genre'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RegistrationPage(
                              registrationType: RegistrationType.GENRE)),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Container(
                height: 50,
                width: double.infinity,
                child: TextButton(
                  style: TextButton.styleFrom(
                      primary: Colors.white, backgroundColor: Colors.blue),
                  child: const Text('Add Publisher'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RegistrationPage(
                              registrationType: RegistrationType.PUBLISHER)),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Container(
                height: 50,
                width: double.infinity,
                child: TextButton(
                  style: TextButton.styleFrom(
                      primary: Colors.white, backgroundColor: Colors.blue),
                  child: const Text('Add Author'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RegistrationPage(
                              registrationType: RegistrationType.AUTHOR)),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Container(
                height: 50,
                width: double.infinity,
                child: TextButton(
                  style: TextButton.styleFrom(
                      primary: Colors.white, backgroundColor: Colors.blue),
                  child: const Text('Add Book'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BookPage()),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Container(
                height: 50,
                width: double.infinity,
                child: TextButton(
                  style: TextButton.styleFrom(
                      primary: Colors.white, backgroundColor: Colors.blue),
                  child: const Text('List Publisher/Book'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BookListPage()),
                    );
                  },
                ),
              ),
            ],
          ),
        ));
  }
}

class RegistrationPage extends StatefulWidget {
  final RegistrationType registrationType;

  RegistrationPage({required this.registrationType});
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  RegistrationType get registrationType => widget.registrationType;

  final controller = TextEditingController();

  void addRegistration() async {
    if (controller.text.trim().isEmpty) {
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text(
            'Empty ${registrationType.description}',
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.blue,
        ));
      return;
    }
    await doSaveRegistration(controller.text.trim());
    controller.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New ${registrationType.description}'),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Container(
              padding: const EdgeInsets.fromLTRB(17.0, 1.0, 7.0, 1.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      autocorrect: true,
                      textCapitalization: TextCapitalization.sentences,
                      controller: controller,
                      decoration: InputDecoration(
                          labelText: "New ${registrationType.description}",
                          labelStyle: const TextStyle(color: Colors.blue)),
                    ),
                  ),
                  ElevatedButton(
                      child: const Text("ADD"), onPressed: addRegistration)
                ],
              )),
          Expanded(
              child: FutureBuilder<List<dynamic>?>(
                  future: doListRegistration(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                        return Center(
                          child: Container(
                              width: 100,
                              height: 100,
                              child: const CircularProgressIndicator()),
                        );
                      default:
                        if (snapshot.hasError) {
                          return const Center(
                            child: const Text("Error..."),
                          );
                        } else {
                          return ListView.builder(
                              padding: const EdgeInsets.only(top: 10.0),
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(snapshot.data![index]
                                      .get<String>('name')),
                                );
                              });
                        }
                    }
                  }))
        ],
      ),
    );
  }

  Future<List<ParseObject>?>? doListRegistration() async {
    QueryBuilder<ParseObject> queryRegistration = QueryBuilder<ParseObject>(
        ParseObject(registrationType.className.toString()));
    final ParseResponse apiResponse =
        await queryRegistration.query<ParseObject>();

    if (apiResponse.success && apiResponse.results != null) {
      return apiResponse.results as List<ParseObject>;
    } else {
      return [];
    }
  }

  Future<void> doSaveRegistration(String name) async {
    final registration = ParseObject(registrationType.className.toString())
      ..set('name', name);
    await registration.save();
  }
}

class BookPage extends StatefulWidget {
  @override
  _BookPageState createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  final controllerTitle = TextEditingController();
  final controllerYear = TextEditingController();
  late ParseObject? genre;
  late ParseObject? publisher;
  late List<ParseObject>? authors;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Book'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              autocorrect: false,
              controller: controllerTitle,
              decoration: const InputDecoration(
                  labelText: 'Title', border: const OutlineInputBorder()),
            ),
            const SizedBox(
              height: 16,
            ),
            TextField(
              autocorrect: false,
              keyboardType: TextInputType.number,
              controller: controllerYear,
              maxLength: 4,
              decoration: const InputDecoration(
                  labelText: 'Year', border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: 16,
            ),
            const Text(
              'Publisher',
              style: const TextStyle(fontSize: 16),
            ),
            CheckBoxGroupWidget(
              registrationType: RegistrationType.PUBLISHER,
              onChanged: (value) {
                if (value != null && value.isNotEmpty) {
                  publisher = value.first;
                } else {
                  publisher = null;
                }
              },
            ),
            const SizedBox(
              height: 16,
            ),
            const Text(
              'Genre',
              style: const TextStyle(fontSize: 16),
            ),
            CheckBoxGroupWidget(
              registrationType: RegistrationType.GENRE,
              onChanged: (value) {
                print(value);
                if (value != null && value.isNotEmpty) {
                  genre = value.first;
                } else {
                  genre = null;
                }
              },
            ),
            const SizedBox(
              height: 16,
            ),
            const Text(
              'Author',
              style: const TextStyle(fontSize: 16),
            ),
            CheckBoxGroupWidget(
              multipleSelection: true,
              registrationType: RegistrationType.AUTHOR,
              onChanged: (value) {
                if (value != null && value.isNotEmpty) {
                  authors = value;
                } else {
                  authors = null;
                }
              },
            ),
            const SizedBox(
              height: 24,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              height: 50,
              width: double.infinity,
              child: TextButton(
                style: TextButton.styleFrom(
                    primary: Colors.white, backgroundColor: Colors.blue),
                child: const Text('Save Book'),
                onPressed: () async {
                  if (controllerTitle.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context)
                      ..removeCurrentSnackBar()
                      ..showSnackBar(const SnackBar(
                        content: const Text(
                          'Empty Book Title',
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        duration: const Duration(seconds: 3),
                        backgroundColor: Colors.blue,
                      ));
                    return;
                  }

                  if (controllerYear.text.trim().length != 4) {
                    ScaffoldMessenger.of(context)
                      ..removeCurrentSnackBar()
                      ..showSnackBar(const SnackBar(
                        content: const Text(
                          'Invalid Year',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        duration: const Duration(seconds: 3),
                        backgroundColor: Colors.blue,
                      ));
                    return;
                  }

                  if (genre == null) {
                    ScaffoldMessenger.of(context)
                      ..removeCurrentSnackBar()
                      ..showSnackBar(const SnackBar(
                        content: const Text(
                          'Select Genre',
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        duration: const Duration(seconds: 3),
                        backgroundColor: Colors.blue,
                      ));
                    return;
                  }

                  if (publisher == null) {
                    ScaffoldMessenger.of(context)
                      ..removeCurrentSnackBar()
                      ..showSnackBar(const SnackBar(
                        content: const Text(
                          'Select Publisher',
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        duration: const Duration(seconds: 3),
                        backgroundColor: Colors.blue,
                      ));
                    return;
                  }

                  if (authors == null) {
                    ScaffoldMessenger.of(context)
                      ..removeCurrentSnackBar()
                      ..showSnackBar(const SnackBar(
                        content: Text(
                          'Select Author',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        duration: const Duration(seconds: 3),
                        backgroundColor: Colors.blue,
                      ));
                    return;
                  }

                  doSaveBook();

                  ScaffoldMessenger.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(const SnackBar(
                      content: const Text(
                        'Book save',
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      duration: const Duration(seconds: 3),
                      backgroundColor: Colors.blue,
                    ));
                  await Future.delayed(const Duration(seconds: 3));
                  Navigator.of(context).pop();
                },
              ),
            ),
            const SizedBox(
              height: 16,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> doSaveBook() async {
    final book = ParseObject('Books')
      ..set('title', controllerTitle.text.trim())
      ..set('year', int.parse(controllerYear.text.trim()))
      ..set('genre', ParseObject('genre')..objectId = genre!.objectId)
      ..set(
          'publisher',
          ParseObject('Publisher')
            ..objectId = publisher!.objectId
            ..toPointer());
    await book.save();
  }
}

class CheckBoxGroupWidget extends StatefulWidget {
  final Function(List<ParseObject>) onChanged;
  final RegistrationType registrationType;
  final bool multipleSelection;

  const CheckBoxGroupWidget(
      {required this.registrationType,
      required this.onChanged,
      this.multipleSelection = false});

  @override
  _CheckBoxGroupWidgetState createState() => _CheckBoxGroupWidgetState();
}

class _CheckBoxGroupWidgetState extends State<CheckBoxGroupWidget> {
  List<ParseObject> selectedItems = [];
  List<ParseObject> items = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    doListRegistration(widget.registrationType).then(<ParseObject>(value) {
      if (value != null) {
        setState(() {
          items = value;
          isLoading = false;
        });
      }
    });
  }

  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
        child: Container(
            width: 100, height: 100, child: const CircularProgressIndicator()),
      );
    }

    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: const EdgeInsets.only(top: 8.0),
        itemCount: items.length,
        itemBuilder: (context, index) {
          return checkBoxTile(items[index]);
        });
  }

  Future<List?> doListRegistration(RegistrationType registrationType) async {
    QueryBuilder<ParseObject> queryRegistration = QueryBuilder<ParseObject>(
        ParseObject(registrationType.className.toString()));
    final ParseResponse apiResponse = await queryRegistration.query();

    if (apiResponse.success && apiResponse.results != null) {
      items.addAll(apiResponse.results!.map((e) => e as ParseObject));
      return apiResponse.results;
    } else {
      return [];
    }
  }

  Widget checkBoxTile(ParseObject? data) {
    return CheckboxListTile(
      title: Text(data!.get<String>('name').toString()),
      value: selectedItems.contains(data),
      onChanged: (value) {
        if (value == true) {
          setState(() {
            if (!widget.multipleSelection) {
              selectedItems.clear();
            }
            selectedItems.add(data);
            widget.onChanged(selectedItems);
          });
        } else {
          setState(() {
            selectedItems.remove(data);
            widget.onChanged(selectedItems);
          });
        }
      },
    );
  }
}

class BookListPage extends StatefulWidget {
  @override
  _BookListPageState createState() => _BookListPageState();
}

class _BookListPageState extends State<BookListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Book List"),
        centerTitle: true,
      ),
      body: FutureBuilder<List<ParseObject>>(
          future: getPublisherList(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                  child: Container(
                      width: 100,
                      height: 100,
                      child: const CircularProgressIndicator()),
                );
              default:
                if (snapshot.hasError) {
                  return const Center(
                    child: const Text("Error..."),
                  );
                } else {
                  return ListView.builder(
                      padding: const EdgeInsets.only(top: 8),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final varPublisher = snapshot.data![index];
                        final varName = varPublisher.get<String>('name');
                        return ExpansionTile(
                          title: Text(varName!),
                          //tilePadding: Icon,
                          children: [
                            BookTile(varPublisher.objectId.toString())
                          ],
                        );
                      });
                }
            }
          }),
    );
  }

  Future<List<ParseObject>> getPublisherList() async {
    QueryBuilder<ParseObject> queryPublisher =
        QueryBuilder<ParseObject>(ParseObject('Publisher'));
    final ParseResponse apiResponse = await queryPublisher.query<ParseObject>();

    if (apiResponse.success && apiResponse.results != null) {
      return apiResponse.results as List<ParseObject>;
    } else {
      return [];
    }
  }
}

class BookTile extends StatefulWidget {
  final String publisherId;

  BookTile(this.publisherId);

  @override
  _BookTileState createState() => _BookTileState();
}

class _BookTileState extends State<BookTile> {
  final controllerBook = TextEditingController();
  String get publisherId => widget.publisherId;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ParseObject>>(
        future: getBookList(publisherId),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Container(
                    width: 100,
                    height: 100,
                    child: const CircularProgressIndicator()),
              );
            default:
              if (snapshot.hasError) {
                return const Center(
                  child: const Text("Error..."),
                );
              } else {
                if (snapshot.hasData) {
                  return ListView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(top: 8),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final book = snapshot.data![index];
                        return ListTile(
                          trailing: const Icon(Icons.arrow_forward_ios),
                          title: Text(book.get<String>('title').toString()),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BookDetailPage(book),
                                ));
                          },
                        );
                      });
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        const Center(
                          child: Text('Books not Found'),
                        ),
                      ],
                    ),
                  );
                }
              }
          }
        });
  }

  Future<List<ParseObject>> getBookList(String publisherId) async {
    QueryBuilder<ParseObject> querybook = QueryBuilder(ParseObject('Book'))
      ..whereEqualTo('publisher',
          (ParseObject('Publisher')..objectId = publisherId).toPointer())
      ..orderByAscending('title');
    final ParseResponse apiResponse = await querybook.query();
    if (apiResponse.success && apiResponse.result != null) {
      return apiResponse.results as List<ParseObject>;
    }
    return [];
  }
}

class BookDetailPage extends StatefulWidget {
  final ParseObject book;

  BookDetailPage(this.book);

  @override
  _BookDetailPageState createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  ParseObject get book => widget.book;

  bool loadedData = false;
  bool isLoading = true;

  late String bookTitle;
  late int bookYear;
  late String bookGenre;
  late String bookPublisher;
  late List<String> bookAuthors;

  @override
  void initState() {
    super.initState();
    getBookDetail(book).then((value) {
      {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(book.get<String>('title').toString()),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: bodyWidget(),
        ));
  }

  Widget bodyWidget() {
    if (isLoading) {
      return Center(
        child: Container(
            width: 100, height: 100, child: const CircularProgressIndicator()),
      );
    }

    if (!loadedData) {
      return const Center(
          child: Text(
        'Error retrieving data ...',
        style: TextStyle(fontSize: 18, color: Colors.red),
      ));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Title: $bookTitle'),
        const SizedBox(
          height: 8,
        ),
        Text('Year: $bookYear'),
        const SizedBox(
          height: 8,
        ),
        const Divider(),
        Text('Genre: $bookGenre'),
        const SizedBox(
          height: 8,
        ),
        const Divider(),
        Text('Publisher: $bookPublisher'),
        const SizedBox(
          height: 8,
        ),
        const Divider(),
        const Text('Authors'),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: bookAuthors.map((a) => Text(a)).toList(),
        )
      ],
    );
  }

  Future getBookDetail(ParseObject book) async {}
}
