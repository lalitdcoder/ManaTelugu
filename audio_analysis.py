#!/usr/bin/env python3
import os
import re

# Define the sounds directory
sounds_dir = "/Users/pavan/Desktop/ManaTelugu/ManaTelugu/Resources/Sounds"

# Get all audio files in the sounds directory
audio_files = []
if os.path.exists(sounds_dir):
    for file in os.listdir(sounds_dir):
        if file.endswith(('.mp3', '.m4a', '.wav')):
            audio_files.append(file)

print(f"Found {len(audio_files)} audio files in Sounds directory")

# Telugu letters from the lesson data
telugu_letters = [
    # Vowels
    "అ", "ఆ", "ఇ", "ఈ", "ఉ", "ఊ", "ఋ", "ౠ", "ఎ", "ఏ", "ఐ", "ఒ", "ఓ", "ఔ", "అం", "అః",
    
    # Consonants
    "క", "ఖ", "గ", "ఘ", "ఙ",
    "చ", "ఛ", "జ", "ఝ", "ఞ", 
    "ట", "ఠ", "డ", "ఢ", "ణ",
    "త", "థ", "ద", "ధ", "న",
    "ప", "ఫ", "బ", "భ", "మ",
    "య", "ర", "ల", "వ",
    "శ", "ష", "స", "హ",
    "ళ", "క్ష", "ఱ"
]

# Vocabulary words from EmbeddedWordsData (simplified list)
vocabulary_words = [
    # Family
    "అమ్మ", "నాన్న", "అక్క", "అన్న", "తమ్ముడు", "చెల్లి", "తాత", "అవ్వ", "మామ", "పిన్ని",
    
    # Colors  
    "ఎరుపు", "నీలం", "పసుపు", "ఆకుపచ్చ", "నలుపు", "తెలుపు", "ఊదా", "నారింజ", "గులాబీ", "గోధుమ",
    
    # Animals
    "పులి", "ఏనుగు", "సింహం", "జింక", "కుక్క", "పిల్లి", "పక్షి", "చేప", "అడవి", "జంతువు",
    
    # Food
    "అన్నం", "రొట్టె", "పాలు", "నీళ్లు", "కూర", "పండు", "కాయ", "బియ్యం", "అన్నపూర్ణ", "రుచి",
    
    # Body Parts
    "తల", "కళ్ళు", "చెవులు", "ముక్కు", "నోరు", "చేతులు", "కాళ్లు", "గుండె", "మెదడు", "ఎముక",
    
    # Nature
    "సూర్యుడు", "చంద్రుడు", "నక్షత్రాలు", "ఆకాశం", "భూమి", "వృక్షం", "పువ్వు", "ఆకు", "పర్వతం", "నది",
    
    # Weather
    "వర్షం", "ఎండ", "మేఘం", "గాలి", "వేడి", "చలి", "మంచు", "విద్యుత్", "గర్జన", "వాతావరణం",
    
    # Numbers (basic)
    "ఒకటి", "రెండు", "మూడు", "నాలుగు", "ఐదు", "ఆరు", "ఏడు", "ఎనిమిది", "తొమ్మిది", "పది"
]

# Check for missing letter audio files
print("\n=== MISSING LETTER AUDIO FILES ===")
missing_letters = []
for letter in telugu_letters:
    # Check various possible file formats
    possible_files = [
        f"{letter}.mp3",
        f"{letter}.m4a", 
        f"{letter}.wav"
    ]
    
    found = False
    for possible_file in possible_files:
        if possible_file in audio_files:
            found = True
            break
    
    if not found:
        missing_letters.append(letter)
        print(f"Missing: {letter}")

print(f"\nTotal missing letter audio files: {len(missing_letters)}")

# Check for missing vocabulary audio files
print("\n=== MISSING VOCABULARY AUDIO FILES ===")
missing_vocab = []
for word in vocabulary_words:
    # Check various possible file formats
    possible_files = [
        f"{word}.mp3",
        f"{word}.m4a",
        f"{word}.wav"
    ]
    
    found = False
    for possible_file in possible_files:
        if possible_file in audio_files:
            found = True
            break
    
    if not found:
        missing_vocab.append(word)
        print(f"Missing: {word}")

print(f"\nTotal missing vocabulary audio files: {len(missing_vocab)}")

# Show available files for reference
print(f"\n=== AVAILABLE AUDIO FILES ({len(audio_files)}) ===")
for file in sorted(audio_files):
    if not file.startswith('.'):  # Skip hidden files
        print(file)

# Summary
print(f"\n=== SUMMARY ===")
print(f"Total Telugu letters expected: {len(telugu_letters)}")
print(f"Missing letter audio files: {len(missing_letters)}")
print(f"Total vocabulary words expected: {len(vocabulary_words)}")
print(f"Missing vocabulary audio files: {len(missing_vocab)}")
print(f"Total audio files available: {len(audio_files)}")
print(f"Total missing audio files: {len(missing_letters) + len(missing_vocab)}")

# Create lists for easy reference
if missing_letters:
    print(f"\nMissing letters: {', '.join(missing_letters)}")

if missing_vocab:
    print(f"\nMissing vocabulary (first 20): {', '.join(missing_vocab[:20])}")
    if len(missing_vocab) > 20:
        print(f"... and {len(missing_vocab) - 20} more")
