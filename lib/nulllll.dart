/*
   Container(
              width: width,
              height: height * 0.5,
              child: FutureBuilder<DocumentSnapshot>(
                future:
                    FirebaseFirestore.instance.collection('Rider').doc().get(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    } else {
                      final data = snapshot.data;
                      return Column(
                        children: [
                          const SizedBox(height: 20),
                          const Divider(
                            thickness: 2,
                            color: Colors.grey,
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 2),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.amber,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Container(
                              // margin: EdgeInsets.symmetric(vertical: 2),
                              margin: EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 15),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.amber,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: ExpansionTile(
                                trailing: Text(
                                  '\$${data!['RiderEarnings']}',
                                  style: GoogleFonts.lato(
                                    textStyle: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  'Name: ${data!['RiderName']}',
                                  style: GoogleFonts.lato(
                                    textStyle: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                subtitle: Text(
                                  'Email: ${data!['RiderEmail']}',
                                  style: GoogleFonts.lato(
                                    textStyle: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),

                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors
                                              .amber, // Set the button's color to amber
                                        ),
                                        onPressed: () {
                                          UpdateData(
                                            context,
                                            data!['RiderUID'],
                                            data!['RiderEarnings'],
                                          );
                                          // Navigator.push(
                                          //   context,
                                          //   MaterialPageRoute(
                                          //     builder: (context) => AdminEmployeeDetailsScreen(model:employee),
                                          //   ),
                                          // );
                                        },
                                        child: Text(
                                          'Collect',
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                                // trailing: Icon(Icons.electric_bike_outlined,),
                              ),
                            ),

*/