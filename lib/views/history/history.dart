// History Page
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:woman_safety/controllers/sos_history_controller.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final soshistory=Get.put(SosHistoryController());
    soshistory.getHitory();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text('SOS History'),
      ),
      body:Obx(
          ()=>
          soshistory.isLoading.value==true?const Center(child: CircularProgressIndicator(),): Column(
            children: [
              Expanded(
                child:soshistory.sos_history.isEmpty?const Center(child: Text("No History Found"),): ListView.builder(
                    itemCount: soshistory.sos_history.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                soshistory.sos_history[index].name!,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Row(
                                children: [
                                  const Icon(Icons.access_time, size: 16.0),
                                  const SizedBox(width: 4.0),
                                  SizedBox(
                                  
                                    width: MediaQuery.of(context).size.width *0.6,
                                    child: Text(
                                      soshistory.sos_history[index].address!,
                                      maxLines: 2,
                                                                    overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 14.0),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8.0),
                              Row(
                                children: [
                                  const Icon(Icons.phone, size: 16.0),
                                  const SizedBox(width: 4.0),
                                  Expanded(
                                    child: Text(
                                      soshistory.sos_history[index].phoneNumber!,
                                      maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 14.0),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              ),
              const SizedBox(height: 90,),
            ],
          ),

      ),
    );
  }
}
