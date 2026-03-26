import 'package:flutter/material.dart';

class WhatsNewDialog extends StatelessWidget {
  final VoidCallback onClose;

  const WhatsNewDialog({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF2D2D3A),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 500),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFF7B1FA2),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: const Text(
                '🎉 WHAT\'S NEW v26.6',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            
            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildNewFeature(
                      '🚫 NO MORE SCROLLING!',
                      'Complete redesign - everything fits on screen!\n'
                      'Zero scrolling needed for any action\n'
                      'Compact layout with perfect screen fit',
                    ),
                    _buildNewFeature(
                      '🎯 ACTIONS SORTED BY IMPORTANCE',
                      '🥇 MOST CRITICAL: Feed, Play, Sleep\n'
                      '🥈 VERY IMPORTANT: Clean, Train, Medicine\n'
                      'Priority-based layout - most important actions first',
                    ),
                    _buildNewFeature(
                      '⌨️ FULL KEYBOARD SUPPORT',
                      'F - Feed, P - Play, C - Clean, S - Sleep\n'
                      'T - Train, M - Medicine, G - Games, O - Course\n'
                      'Complete keyboard navigation - no touch needed!',
                    ),
                    _buildNewFeature(
                      '🔊 ENHANCED SOUND SYSTEM',
                      'Multi-modal feedback: Sound → Haptic → Visual\n'
                      'Better error handling and fallback systems\n'
                      'Works even if sound is disabled',
                    ),
                    _buildNewFeature(
                      '♿ ACCESSIBILITY IMPROVEMENTS',
                      'Larger touch targets (80px height)\n'
                      'Bigger fonts (14px) for better readability\n'
                      'Thicker borders and enhanced visual feedback',
                    ),
                    _buildNewFeature(
                      '📱 COMPACT DESIGN',
                      'Fixed header (60px) with essential info\n'
                      'Compact pet avatar (100px) + quick stats\n'
                      '3x2 action grid - everything visible at once',
                    ),
                    _buildNewFeature(
                      '⚡ INSTANT ACCESS',
                      'Direct obstacle course access from header\n'
                      'Games button always visible at bottom\n'
                      'No menus to dig through - one-tap access',
                    ),
                    _buildNewFeature(
                      '🎮 ALL 7 GAMES PLAYABLE',
                      '🧩 Puzzle, 📝 Quiz, 🏃 Racing - all working!\n'
                      '🧠 Memory, 🎯 Catch, 🎵 Rhythm - enhanced\n'
                      'Every game gives XP, coins, and gems',
                    ),
                    _buildNewFeature(
                      '💕 BFF STATUS SYSTEM',
                      '80%+ friendship = "Besties" 🤗\n'
                      '95%+ friendship = "BFF" 💕\n'
                      'Beautiful color-coded progression with emojis',
                    ),
                    _buildNewFeature(
                      '📊 ENHANCED STATS DISPLAY',
                      '🧠 Intelligence: Genius 🧠 (80%+), Smart 🎓 (60%+)\n'
                      '👥 Social: Social Star ⭐ (80%+), Popular 🎉 (60%+)\n'
                      '🌟 Perfect Care (90%+), ⭐ Excellent (80%+)',
                    ),
                    _buildNewFeature(
                      '🏃‍♂️ OBSTACLE COURSE ACCESS',
                      'Direct access from main screen header\n'
                      'No digging through menus needed\n'
                      'Instant play - one tap away',
                    ),
                    _buildNewFeature(
                      '📁 USB DATA TRANSFER',
                      '💾 Export pet data to Downloads folder via USB\n'
                      '📥 Import pet data from Downloads folder\n'
                      '🔄 Complete data backup and restore system\n'
                      '⚡ Transfer stats, items, achievements, progress',
                    ),
                    _buildNewFeature(
                      '🎨 CUSTOMIZATION SYSTEM',
                      '👗 8 Accessories: Hat, Scarf, Glasses, Bow, Collar, Crown, Wings, Halo\n'
                      '🎨 6 Themes: Default, Dark, Ocean, Forest, Sunset, Galaxy\n'
                      '📏 Pet Size Slider: 50% to 150% size adjustment\n'
                      '💰 Buy with Gems or Coins - Real-time preview',
                    ),
                    _buildNewFeature(
                      '⚙️ SETTINGS & CUSTOMIZATION',
                      'Full settings menu with sound toggle\n'
                      'Customization options for your pet\n'
                      'Accessibility settings and preferences',
                    ),
                    _buildNewFeature(
                      '🎨 VISUAL POLISH',
                      'Smoother animations and transitions\n'
                      'Better color contrast and visibility\n'
                      'Enhanced visual feedback for all interactions',
                    ),
                  ],
                ),
              ),
            ),
            
            // Footer
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFF3D3D4A),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Column(
                children: [
                  const Text(
                    '🌟 Ultimate efficiency update - no scrolling needed!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Version 26.6 - Redesigned for speed and accessibility',
                    style: TextStyle(
                      color: Colors.grey[300],
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: onClose,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7B1FA2),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Let\'s Play!',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewFeature(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.cyan,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
