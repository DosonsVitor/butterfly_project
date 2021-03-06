import 'package:flutter/material.dart';

class Book {
  final String Nome;
  final String Autor;
  final String Sinopse;
  final Color Cor01;
  final Color Cor02;
  final int Paginas;
  final int PaginasLidas;
  final IconData Icon;
  final String Status;

  Book({
    required this.Nome,
    required this.Autor,
    this.Sinopse = "",
    required this.Cor01,
    required this.Cor02,
    required this.Paginas,
    required this.PaginasLidas,
    required this.Icon,
    this.Status = "lista_leitura",
  });
}
