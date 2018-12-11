library rapido;

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class ImageFormField extends StatefulWidget {
  /// The name of the field, used to calculate which type of input to return
  final String fieldName;

  /// The label to display in the UI for the specified fieldName
  final String label;

  /// Call back function invoked when the Form parent of the FormField is
  /// saved. The value returned is determined by the type of the field.
  final Function onSaved;

  /// The initial value to display in the FormField.
  final String initialValue;

  ImageFormField(this.fieldName,
      {@required this.label, @required this.onSaved, this.initialValue});
  _ImageFormFieldState createState() => _ImageFormFieldState();
}

class _ImageFormFieldState extends State<ImageFormField> {
  File _imageFile;
  bool _dirty = false;

@override
  void initState() {
    if(widget.initialValue != null) {
      print(" ********** ${widget.initialValue}");
      Uri uri = Uri(path: widget.initialValue);
      _imageFile = File.fromUri(uri);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FormField(
      builder: (FormFieldState<String> state) {
        return Row(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(border: Border.all()),
              child: SizedBox(
                height: 200.0,
                width: 200.00,
                child: _buildImageWidget(),
              ),
            ),
            IconButton(
              icon: Icon(Icons.image),
              onPressed: () {
                _setImageFile(ImageSource.gallery);
              },
            ),
            IconButton(
              icon: Icon(Icons.camera),
              onPressed: () {
                _setImageFile(ImageSource.camera);
              },
            ),
          ],
        );
      },
      onSaved: (String path) async{
        if(_dirty){
          Directory dir = await getApplicationDocumentsDirectory();
          String path = dir.path;
          String filename = basename(_imageFile.path);
          File newFile = _imageFile.copySync("$path/$filename");
          widget.onSaved(newFile.path);

        }
        else {
          widget.onSaved(widget.initialValue);
        }
      },
    );
  }

  void _setImageFile(ImageSource source) async {
    ImagePicker.pickImage(source: source).then((File file) async {
      setState(() {
        _imageFile = file;
        _dirty = true;
      });
    });
  }

  Widget _buildImageWidget() {
    if (_imageFile == null) {
      return Icon(
        Icons.image,
        size: 150.0,
      );
    } else {
      return Image.file(
        _imageFile,
        fit: BoxFit.scaleDown,
      );
    }
  }
}
