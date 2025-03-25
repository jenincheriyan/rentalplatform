// import 'dart:io';

import 'dart:io';

import 'package:rental_platform/rental/blocs/blocs.dart';
import 'package:rental_platform/rental/blocs/image/image_bloc.dart';
import 'package:rental_platform/rental/models/rental.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rental_platform/rental/screens/HomeScreen.dart';
import 'package:image_picker/image_picker.dart';

import '../../routes.dart';
import 'rental_list.dart';

class AddUpdateRental extends StatefulWidget {
  static const routeName = 'courseAddUpdate';
  final RentalArguments args;

  AddUpdateRental({required this.args});
  @override
  _AddUpdateRentalState createState() => _AddUpdateRentalState();
}

class _AddUpdateRentalState extends State<AddUpdateRental> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final Map<String, dynamic> _course = {};

  Future<void> _onAddPhotoClicked(context) async {
    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      _course["rentalImage"] = image.path; // Store file path as a String
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        title:
            Text('${widget.args.edit ? "Edit Property" : "Add New Gadget"}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                  key: const ValueKey("address"),
                  initialValue:
                      widget.args.edit ? widget.args.rental?.address : '',
                  validator: (value) {
                    if (value != null && value.isEmpty) {
                      return 'Please enter details';
                    }
                    return null;
                  },
                  decoration: InputDecoration(labelText: 'Enter Gadget Name, Location, Rate'),
                  onSaved: (value) {
                    setState(() {
                      this._course["address"] = value;
                    });
                  }),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: BlocBuilder<ImageBloc, ImageState>(
                  builder: (context, state) {
                    var image = widget.args.rental?.rentalImage;
                    if (image != null && state is ImageInitial) {
                      print("MY IMAGE $image");
                      print("DEBUG: _course['rentalImage'] = ${this._course["rentalImage"]}");
                      print("DEBUG: Type of _course['rentalImage'] = ${this._course["rentalImage"].runtimeType}");
                      return Image.network("http://127.0.0.1:3000/${image}");
                    } else if (state is ImageUploaded) {
                      print(this._course["rentalImage"]);
                      return Image.file(
                        File(this._course["rentalImage"]) // ✅ Correct
                        ,
                        height: 500,
                      );
                    }

                    return Image.asset(
                      "./assets/images/placeholder.jpg",
                      height: 300,
                    );
                  },
                ),
              ),
              ElevatedButton(
                  key: const ValueKey("addimage"),
                  onPressed: () async {
                    await _onAddPhotoClicked(context);
                    BlocProvider.of<ImageBloc>(context).add(UploadImage());
                    // print(_course["rentalImage"]);
                  },
                  child: Icon(Icons.add)),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton.icon(
                  onPressed: () {
                    final form = _formKey.currentState;
                    if (form != null && form.validate()) {
                      form.save();
                      final RentalEvent event = widget.args.edit
                          ? RentalUpdate(
                              Rental(
                                address: this._course["address"],
                                rentalImage: this._course["rentalImage"],
                              ),
                              widget.args.rental!.sId!)
                          : RentalCreate(
                              Rental(
                                address: this._course["address"],
                                rentalImage: this._course["rentalImage"],
                              ),
                            );
                      BlocProvider.of<RentalBloc>(context).add(event);
                      BlocProvider.of<ImageBloc>(context).add(UsePlaceHolder());
                      Navigator.of(context).pushNamed(HomeScreen.routeName);
                    }
                  },
                  label: Text('SAVE'),
                  icon: Icon(Icons.save),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
