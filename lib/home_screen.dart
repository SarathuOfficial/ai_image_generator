import 'package:ai_image_generator/colors.dart';
import 'package:flutter/material.dart';
import 'api_services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var sizes = ["Small", "Medium", "Large"];
  var values = ["256x256", "512x512", "1024x1024"];
  String? dropValue;
  var textController = TextEditingController();
  String image = '';
  var isLoaded = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "AI Image Generator",
          style: TextStyle(
            fontFamily: "poppins_bold",
            color: whiteColor,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 44,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 4),
                          decoration: BoxDecoration(
                            color: whiteColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TextFormField(
                            controller: textController,
                            decoration: const InputDecoration(
                              hintText: "eg 'A monkey on moon'",
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        height: 44,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: whiteColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            icon: const Icon(
                              Icons.expand_more,
                              color: btnColor,
                            ),
                            value: dropValue,
                            hint: const Text("Select size"),
                            items: List.generate(
                              sizes.length,
                              (index) => DropdownMenuItem(
                                value: values[index],
                                child: Text(sizes[index]),
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                dropValue = value.toString();
                              });
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    width: 300,
                    height: 44,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: btnColor,
                        shape: const StadiumBorder(),
                      ),
                      onPressed: () async {
                        if (textController.text.isNotEmpty &&dropValue != null) {
                          setState(() {
                            isLoaded = false;
                          });
                          image = await Api.generateImage(textController.text, dropValue!);
                          setState(() {
                            isLoaded = true;
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please pass the text and size"),
                            ),
                          );
                        }
                      },
                      child: const Text("Generate"),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 4,
              child: isLoaded
                  ? Image.network(image)
                  : Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: whiteColor),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset("assets/loader.gif"),
                          ]),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
