import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MissionCompletionOverlay extends StatefulWidget {
  final String missionTitle;
  final VoidCallback onSkip;
  final Function(File? imageFile, int rating) onSubmit;

  const MissionCompletionOverlay({
    Key? key,
    required this.missionTitle,
    required this.onSkip,
    required this.onSubmit,
  }) : super(key: key);

  @override
  State<MissionCompletionOverlay> createState() => _MissionCompletionOverlayState();
}

class _MissionCompletionOverlayState extends State<MissionCompletionOverlay> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  int _rating = 0;

  Future<void> _pickFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _imageFile = File(image.path);
        });
      }
    } catch (e) {
      // Handle errors here
      print('Error picking image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Mission Completed!',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              widget.missionTitle,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            
            // Show image preview if available, otherwise show upload button
            if (_imageFile != null) 
              _buildImagePreview()
            else
              _buildUploadButton(),
            
            const SizedBox(height: 24),
            
            // Star rating
            Text(
              'Rate this mission:',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 12),
            _buildStarRating(),
            const SizedBox(height: 24),
            
            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: widget.onSkip,
                  child: const Text('Skip'),
                ),
                ElevatedButton(
                  onPressed: () => widget.onSubmit(_imageFile, _rating),
                  child: const Text('Submit'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildImagePreview() {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.file(
            _imageFile!,
            height: 180,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: InkWell(
            onTap: () {
              setState(() {
                _imageFile = null;
              });
            },
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                color: Colors.black,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildUploadButton() {
    return Column(
      children: [
        Center(
          child: InkWell(
            onTap: _pickFromGallery,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.add_photo_alternate,
                size: 40,
                color: Colors.grey,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '+10 XP for photo',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
      ],
    );
  }
  
  Widget _buildStarRating() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        final starValue = index + 1;
        return IconButton(
          iconSize: 36,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          icon: Icon(
            _rating >= starValue ? Icons.star : Icons.star_border,
            color: _rating >= starValue ? Colors.amber : Colors.grey,
            size: 36,
          ),
          onPressed: () {
            setState(() {
              _rating = starValue;
            });
          },
        );
      }),
    );
  }
} 