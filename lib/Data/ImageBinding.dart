import 'dart:io';
import 'package:flutter/material.dart';

class ImageBinding
{
  late String imagePath;
  late Image image;

  ImageBinding(String path)
  {
    imagePath = path;
    image = Image.file(File(path),fit: BoxFit.contain);
  }

  Image getImage()
  {
    return image;
  }
}