import 'package:flutter/material.dart';
enum PetType { dog, cat, bunny, bird, dragon }
enum PetPersonality { playful, lazy, curious, shy, energetic, calm }
enum PetMood { happy, excited, sleepy, hungry, sad, sick, playful, loving }
enum EvolutionStage { baby, child, teen, adult, elder }

extension PetTypeExtension on PetType {
  String get emoji {
    switch (this) {
      case PetType.dog:
        return '🐶';
      case PetType.cat:
        return '🐱';
      case PetType.bunny:
        return '🐰';
      case PetType.bird:
        return '🐦';
      case PetType.dragon:
        return '🐉';
    }
  }

  String get name {
    switch (this) {
      case PetType.dog:
        return 'Dog';
      case PetType.cat:
        return 'Cat';
      case PetType.bunny:
        return 'Bunny';
      case PetType.bird:
        return 'Bird';
      case PetType.dragon:
        return 'Dragon';
    }
  }

  Color get color {
    switch (this) {
      case PetType.dog:
        return const Color(0xFF8D6E63);
      case PetType.cat:
        return const Color(0xFFFFA726);
      case PetType.bunny:
        return const Color(0xFFFCE4EC);
      case PetType.bird:
        return const Color(0xFF4FC3F7);  // Added missing const
      case PetType.dragon:
        return const Color(0xFF66BB6A);  // Added missing const
    }
  }
}

class Pet {
  String id;
  String name;
  PetType type;
  PetPersonality personality;
  PetMood currentMood;
  EvolutionStage evolutionStage;
  int level;
  int xp;
  int xpToNextLevel;

  // Stats (0-100)
  int hunger;
  int energy;
  int cleanliness;
  int happiness;
  int health;

  // New stats
  int intelligence;
  int social;
  int loyalty;

  // Currency
  int coins;
  int gems;

  // Time tracking
  DateTime createdAt;
  int playTimeMinutes;

  // New features
  List<String> accessories;
  List<String> achievements;
  Map<String, int> skills;
  List<String> inventory;
  int friendshipLevel;
  DateTime lastFed;
  DateTime lastPlayed;
  bool isAsleep;
  String currentAccessory;

  Pet({
    this.id = '',
    required this.name,
    required this.type,
    this.personality = PetPersonality.playful,
    this.currentMood = PetMood.happy,
    this.evolutionStage = EvolutionStage.baby,
    this.level = 1,
    this.xp = 0,
    this.xpToNextLevel = 100,
    this.hunger = 30,
    this.energy = 80,
    this.cleanliness = 70,
    this.happiness = 80,
    this.health = 100,
    this.intelligence = 10,
    this.social = 10,
    this.loyalty = 10,
    this.coins = 100,
    this.gems = 5,
    DateTime? createdAt,
    this.playTimeMinutes = 0,
    this.accessories = const [],
    this.achievements = const [],
    this.skills = const {},
    this.inventory = const [],
    this.friendshipLevel = 0,
    DateTime? lastFed,
    DateTime? lastPlayed,
    this.isAsleep = false,
    this.currentAccessory = '',
  }) : createdAt = createdAt ?? DateTime.now(),
       lastFed = lastFed ?? DateTime.now(),
       lastPlayed = lastPlayed ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type.index,
      'personality': personality.index,
      'currentMood': currentMood.index,
      'evolutionStage': evolutionStage.index,
      'level': level,
      'xp': xp,
      'xpToNextLevel': xpToNextLevel,
      'hunger': hunger,
      'energy': energy,
      'cleanliness': cleanliness,
      'happiness': happiness,
      'health': health,
      'intelligence': intelligence,
      'social': social,
      'loyalty': loyalty,
      'coins': coins,
      'gems': gems,
      'createdAt': createdAt.toIso8601String(),
      'playTimeMinutes': playTimeMinutes,
      'accessories': accessories,
      'achievements': achievements,
      'skills': skills,
      'inventory': inventory,
      'friendshipLevel': friendshipLevel,
      'lastFed': lastFed.toIso8601String(),
      'lastPlayed': lastPlayed.toIso8601String(),
      'isAsleep': isAsleep,
      'currentAccessory': currentAccessory,
    };
  }

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      id: json['id']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: json['name'] ?? 'Unknown Pet',
      type: PetType.values[json['type'] ?? 0],
      personality: PetPersonality.values[json['personality'] ?? 0],
      currentMood: PetMood.values[json['currentMood'] ?? 0],
      evolutionStage: EvolutionStage.values[json['evolutionStage'] ?? 0],
      level: json['level'] ?? 1,
      xp: json['xp'] ?? 0,
      xpToNextLevel: json['xpToNextLevel'] ?? 100,
      hunger: json['hunger'] ?? 30,
      energy: json['energy'] ?? 80,
      cleanliness: json['cleanliness'] ?? 70,
      happiness: json['happiness'] ?? 80,
      health: json['health'] ?? 100,
      intelligence: json['intelligence'] ?? 10,
      social: json['social'] ?? 10,
      loyalty: json['loyalty'] ?? 10,
      coins: json['coins'] ?? 100,
      gems: json['gems'] ?? 5,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      playTimeMinutes: json['playTimeMinutes'] ?? 0,
      accessories: List<String>.from(json['accessories'] ?? []),
      achievements: List<String>.from(json['achievements'] ?? []),
      skills: Map<String, int>.from(json['skills'] ?? {}),
      inventory: List<String>.from(json['inventory'] ?? []),
      friendshipLevel: json['friendshipLevel'] ?? 0,
      lastFed: json['lastFed'] != null ? DateTime.parse(json['lastFed']) : DateTime.now(),
      lastPlayed: json['lastPlayed'] != null ? DateTime.parse(json['lastPlayed']) : DateTime.now(),
      isAsleep: json['isAsleep'] ?? false,
      currentAccessory: json['currentAccessory'] ?? '',
    );
  }

  String get status {
    if (health <= 20) return 'Critical';
    if (hunger >= 80) return 'Starving';  // Fixed: high hunger = starving
    if (energy <= 20) return 'Exhausted';
    if (cleanliness <= 20) return 'Dirty';
    if (happiness <= 20) return 'Sad';
    if (health >= 90 && hunger <= 20 && energy >= 90 && cleanliness >= 90 && happiness >= 90) return 'Perfect';
    if (health >= 80 && hunger <= 30 && energy >= 80 && cleanliness >= 80 && happiness >= 80) return 'Excellent';
    if (health >= 60 && hunger <= 40 && energy >= 60 && cleanliness >= 60 && happiness >= 60) return 'Happy';
    return 'Okay';
  }

  IconData get statusIcon {
    switch (status) {
      case 'Critical':
        return Icons.warning;
      case 'Starving':
        return Icons.restaurant;
      case 'Exhausted':
        return Icons.battery_alert;
      case 'Dirty':
        return Icons.cleaning_services;
      case 'Sad':
        return Icons.sentiment_dissatisfied;
      case 'Happy':
        return Icons.sentiment_very_satisfied;
      case 'Excellent':
        return Icons.star;
      case 'Perfect':
        return Icons.emoji_events;
      default:
        return Icons.sentiment_neutral;
    }
  }

  void addXp(int amount) {
    xp += amount;
    while (xp >= xpToNextLevel) {
      xp -= xpToNextLevel;
      level++;
      xpToNextLevel = (xpToNextLevel * 1.5).round();
      
      // Evolution is checked in decayStats, but let's also check here
      _checkEvolution();
    }
  }

  void decayStats() {
    hunger = (hunger + 2).clamp(0, 100);  // Fixed: hunger increases over time (pet gets hungrier)
    energy = (energy - 1).clamp(0, 100);
    cleanliness = (cleanliness - 1).clamp(0, 100);
    happiness = (happiness - 1).clamp(0, 100);

    // New stats decay
    intelligence = (intelligence - 0.5).clamp(0, 100).toInt();
    social = (social - 1).clamp(0, 100);
    loyalty = (loyalty - 0.3).clamp(0, 100).toInt();

    // Health decreases if other stats are low
    if (hunger > 80 || energy < 30 || cleanliness < 30) {  // Fixed: high hunger is bad
      health = (health - 2).clamp(0, 100);
    } else if (hunger < 30 && energy > 70 && cleanliness > 70 && happiness > 70) {  // Fixed: low hunger is good
      health = (health + 1).clamp(0, 100);
    }

    // Update mood based on stats
    _updateMood();
    
    // Check for evolution
    _checkEvolution();
  }

  void _updateMood() {
    if (health <= 20) {
      currentMood = PetMood.sick;
    } else if (hunger >= 80) {
      currentMood = PetMood.hungry;
    } else if (energy <= 20) {
      currentMood = PetMood.sleepy;
    } else if (happiness <= 20) {
      currentMood = PetMood.sad;
    } else if (happiness >= 90 && energy >= 80) {
      currentMood = PetMood.excited;
    } else if (friendshipLevel >= 50) {
      currentMood = PetMood.loving;
    } else {
      currentMood = PetMood.happy;
    }
  }

  void _checkEvolution() {
    EvolutionStage newStage = evolutionStage;
    
    if (level >= 10 && evolutionStage == EvolutionStage.baby) {
      newStage = EvolutionStage.child;
    } else if (level >= 20 && evolutionStage == EvolutionStage.child) {
      newStage = EvolutionStage.teen;
    } else if (level >= 35 && evolutionStage == EvolutionStage.teen) {
      newStage = EvolutionStage.adult;
    } else if (level >= 50 && evolutionStage == EvolutionStage.adult) {
      newStage = EvolutionStage.elder;
    }
    
    if (newStage != evolutionStage) {
      evolutionStage = newStage;
      // Evolution bonus stats
      health = (health + 20).clamp(0, 100);
      intelligence = (intelligence + 10).clamp(0, 100);
    }
  }

  void addAccessory(String accessory) {
    if (!accessories.contains(accessory)) {
      accessories.add(accessory);
      happiness = (happiness + 10).clamp(0, 100);
    }
  }

  void wearAccessory(String accessory) {
    if (accessories.contains(accessory)) {
      currentAccessory = accessory;
      happiness = (happiness + 5).clamp(0, 100);
    }
  }

  void addAchievement(String achievement) {
    if (!achievements.contains(achievement)) {
      achievements.add(achievement);
      coins += 50;
      gems += 2;
    }
  }

  void levelUpSkill(String skill) {
    skills[skill] = (skills[skill] ?? 0) + 1;
    intelligence = (intelligence + 2).clamp(0, 100);
  }

  void addItem(String item) {
    inventory.add(item);
  }

  void useItem(String item) {
    if (inventory.contains(item)) {
      inventory.remove(item);
      
      switch (item) {
        case 'treat':
          happiness = (happiness + 20).clamp(0, 100); // Better happiness boost
          hunger = (hunger - 15).clamp(0, 100); // Better hunger reduction
          loyalty = (loyalty + 2).clamp(0, 100); // Treats increase loyalty
          break;
        case 'toy':
          happiness = (happiness + 15).clamp(0, 100);
          energy = (energy - 3).clamp(0, 100); // Less energy cost
          social = (social + 2).clamp(0, 100); // Toys increase social skills
          break;
        case 'medicine':
          health = (health + 40).clamp(0, 100); // Better health restoration
          currentMood = PetMood.happy; // Medicine makes pets happy
          break;
        case 'energy_drink':
          energy = (energy + 50).clamp(0, 100); // Much better energy boost
          happiness = (happiness + 5).clamp(0, 100); // Energy drinks are fun
          break;
      }
    }
  }

  void increaseFriendship() {
    friendshipLevel = (friendshipLevel + 1).clamp(0, 100);
    loyalty = (loyalty + 2).clamp(0, 100);
  }

  String get evolutionEmoji {
    switch (evolutionStage) {
      case EvolutionStage.baby:
        return '👶';
      case EvolutionStage.child:
        return '🧒';
      case EvolutionStage.teen:
        return '🧑';
      case EvolutionStage.adult:
        return '👨';
      case EvolutionStage.elder:
        return '👴';
    }
  }

  String get moodEmoji {
    switch (currentMood) {
      case PetMood.happy:
        return '😊';
      case PetMood.excited:
        return '🤗';
      case PetMood.sleepy:
        return '😴';
      case PetMood.hungry:
        return '🍽️';
      case PetMood.sad:
        return '😢';
      case PetMood.sick:
        return '🤒';
      case PetMood.playful:
        return '🎮';
      case PetMood.loving:
        return '❤️';
    }
  }

  void updateColor(Color color) {
    // This method allows dynamic color updates for premium themes
    // The actual color is managed by the theme system
  }
}