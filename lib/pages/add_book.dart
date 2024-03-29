import 'package:butterfly_project/data/book_dao.dart';
import 'package:butterfly_project/widget/generic_body.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:multi_select_flutter/dialog/mult_select_dialog.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:uuid/uuid.dart';

import '../domain/book.dart';
import '../widget/choice_button.dart';
import '../widget/generic_appbar.dart';

class AddBook extends StatefulWidget {
  const AddBook({super.key});

  @override
  State<AddBook> createState() => _AddBookState();
}

class _AddBookState extends State<AddBook> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController autorController = TextEditingController();
  TextEditingController sinopseController = TextEditingController();
  TextEditingController pagesController = TextEditingController();
  TextEditingController pagesReadController = TextEditingController();
  TextEditingController color1Controller = TextEditingController();
  TextEditingController color2Controller = TextEditingController();
  TextEditingController iconUrlController = TextEditingController();


  Color pickerColor = const Color(0xff443a49);
  Color currentColor = const Color(0xff443a49);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: GenericAppBar(
          title: "Adicionar Livro",
          leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              }), actions: [],
        ),
      ),
      body: GenericBody(items: [
        createTextInput(Icons.title_outlined, "Titulo", titleController, null),
        createTextInput(Icons.auto_stories_rounded, "Autor", autorController, null),
        createTextInput(Icons.abc, "Sinopse", sinopseController, null),
        createNumberInput(Icons.library_books, "Paginas", pagesController, null),
        createNumberInput(Icons.library_books, "Paginas Lidas", pagesReadController, null),
        ChoiceButton(name: "Status", tap: () => _showMultiSelect(context, List.from(["Lista de Leitura", "Lendo", "Pausado", "Lido"]))),
        ChoiceButton(name: "Cor Primaria", tap: () => showColorPicker(context, color1Controller)),
        ChoiceButton(name: "Cor Segundaria", tap: () => showColorPicker(context, color2Controller)),
        createTextInput(Icons.library_books, "Link do icone", iconUrlController, null),
      ],),

      floatingActionButton: FloatingActionButton(
        onPressed: () => addBook(),
        backgroundColor: Colors.transparent,
        child: Container(
          width: 200,
          height: 200,
          decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(colors: [Colors.purple, Colors.deepPurple])
          ),
          child: const Icon(Icons.check),
        ),
      ),
    );
  }

  showSnackBar(String msg) {
    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 32,
      ),
      content: Text(msg),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _showMultiSelect(BuildContext context, List<String> items) async {
    await showDialog(
      context: context,
      builder: (ctx) {
        return MultiSelectDialog(
          items: items.map((e) => MultiSelectItem(e, e)).toList(),
          initialValue: [],
          onConfirm: (values) {},
        );
      },
    );
  }

  void showColorPicker(BuildContext context, controller) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pick a color!'),
          content: SingleChildScrollView(
            child: ColorPicker(
              hexInputController: controller,
              pickerColor: pickerColor,
              onColorChanged: changeColor,
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Got it'),
              onPressed: () {
                setState(() => currentColor = pickerColor);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  addBook() async{
    String newBookTitle = titleController.text;
    int newBookPages = int.parse(pagesController.text);
    int newBookPagesRead = int.parse(pagesReadController.text);
    String newBookAutor = autorController.text;
    String newBookSinopse = sinopseController.text;
    String newBookCor1 = color1Controller.text;
    String newBookCor2 = color2Controller.text;
    String newBookIcon = iconUrlController.text;

    Book newBook = Book(Id: UuidGenerate(), Nome: newBookTitle, Autor: newBookAutor, Paginas: newBookPages, PaginasLidas: newBookPagesRead, Sinopse: newBookSinopse, Cor1: newBookCor1, Cor2: newBookCor2, IconeURL: newBookIcon);
    await BookDao().addBook(book: newBook);
    showSnackBar("Livro Adicionada com sucesso!");
    Navigator.pop(context);
  }
}

createTextInput(icon, label, controller, value){
  return  Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: TextFormField(
          initialValue: value,
          controller: controller,
          cursorColor: Colors.deepPurple,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(color: Colors.deepPurple),
            focusColor: Colors.deepPurple,
            focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.deepPurple),
                borderRadius: BorderRadius.circular(50)
            ),
            border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.deepPurple),
                borderRadius: BorderRadius.circular(50)
            ),
            icon: Icon(icon, color: Colors.purple),
          )
      )
  );
}

createNumberInput(icon, label, controller, value){
  return Padding(
    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
    child: TextFormField(
      initialValue: value,
      controller: controller,
      cursorColor: Colors.deepPurple,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.deepPurple),
        focusColor: Colors.deepPurple,
        focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.deepPurple),
            borderRadius: BorderRadius.circular(50)
        ),
        border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.deepPurple),
            borderRadius: BorderRadius.circular(50)
        ),
        icon: Icon(icon, color: Colors.purple),
      ),
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly
      ],
    ),
  );
}

String UuidGenerate(){
  var uuid = Uuid();
  return uuid.v4().toString();
}