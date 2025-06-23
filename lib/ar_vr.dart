import 'package:ar_flutter_plugin/datatypes/config_planedetection.dart';
import 'package:ar_flutter_plugin/datatypes/node_types.dart';
import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin/models/ar_hittest_result.dart';
import 'package:ar_flutter_plugin/models/ar_node.dart';
import 'package:ar_flutter_plugin/widgets/ar_view.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
class WatchTryOnScreen extends StatefulWidget {
  @override
  _WatchTryOnScreenState createState() => _WatchTryOnScreenState();
}

class _WatchTryOnScreenState extends State<WatchTryOnScreen> {
  ARSessionManager? arSessionManager;
  ARObjectManager? arObjectManager;
  ARNode? node;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ARView(
        onARViewCreated: onARViewCreated,
        planeDetectionConfig: PlaneDetectionConfig.horizontal,
      ),
    );
  }

  void onARViewCreated(ARSessionManager sessionManager, ARObjectManager objectManager, ARAnchorManager anchorManager, ARLocationManager locationManager) {
    arSessionManager = sessionManager;
    arObjectManager = objectManager;

    arSessionManager!.onInitialize(
      showFeaturePoints: false,
      showPlanes: true,
      customPlaneTexturePath: "Images/triangle.png",
      showAnimatedGuide: true,
    );
    arObjectManager!.onInitialize();

    // When user taps a detected plane
    // import 'package:vector_math/vector_math_64.dart' as vector;

// ...


// Inside onPlaneOrPointTap
    arSessionManager!.onPlaneOrPointTap = (hitResults) async {
      if (hitResults.isNotEmpty) {
        final hit = hitResults.first;

        // Decompose the matrix
        vector.Vector3 position = vector.Vector3.zero();
        vector.Quaternion quaternion = vector.Quaternion.identity();
        vector.Vector3 scale = vector.Vector3.zero();

        hit.worldTransform.decompose(position, quaternion, scale);

        // Convert Quaternion to Vector4
        vector.Vector4 rotationVector4 = vector.Vector4(
          quaternion.x,
          quaternion.y,
          quaternion.z,
          quaternion.w,
        );

        // Create the ARNode
        var newNode = ARNode(
          type: NodeType.localGLTF2,
          uri: "assets/models/watch.glb",
          scale: vector.Vector3(0.05, 0.05, 0.05), // Adjust scale to match wrist
          position: position,
          rotation: rotationVector4, // ✅ Correct type now
        );

        bool? didAdd = await arObjectManager!.addNode(newNode);
        if (didAdd ==true) {
          node = newNode;
        }
      }
    };


  }

  @override
  void dispose() {
    arSessionManager?.dispose();
    super.dispose();
  }
}