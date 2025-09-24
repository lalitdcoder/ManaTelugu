#!/usr/bin/env python3

import re
import shutil

def remove_widget_extension():
    project_file = "ManaTelugu.xcodeproj/project.pbxproj"
    backup_file = "ManaTelugu.xcodeproj/project.pbxproj.backup3"
    
    # Create backup
    shutil.copy2(project_file, backup_file)
    print(f"Created backup: {backup_file}")
    
    with open(project_file, 'r') as f:
        content = f.read()
    
    # Remove widget extension target references
    patterns_to_remove = [
        # Remove widget extension target definition
        r'/\* Begin PBXNativeTarget section \*/\n.*?ManaTeluguWidgetsExtension.*?End PBXNativeTarget section \*/',
        # Remove widget extension from dependencies
        r'/\* ManaTeluguWidgetsExtension \*/ = \{.*?\};',
        # Remove widget extension from target dependencies
        r'/\* ManaTeluguWidgetsExtension \*/,\s*',
        # Remove widget extension build phases
        r'/\* ManaTeluguWidgetsExtension \*/\s*\{[^}]*\},',
        # Remove widget extension from project references
        r'/\* ManaTeluguWidgetsExtension \*/\s*\{[^}]*\},',
        # Remove widget extension from build configurations
        r'/\* ManaTeluguWidgetsExtension \*/\s*\{[^}]*\},',
        # Remove widget extension from target attributes
        r'/\* ManaTeluguWidgetsExtension \*/\s*\{[^}]*\},',
    ]
    
    for pattern in patterns_to_remove:
        content = re.sub(pattern, '', content, flags=re.DOTALL | re.MULTILINE)
    
    # Remove any remaining widget extension references
    content = re.sub(r'ManaTeluguWidgetsExtension', '', content)
    content = re.sub(r'WidgetsExtension', '', content)
    
    # Clean up any double commas or empty sections
    content = re.sub(r',\s*,', ',', content)
    content = re.sub(r'\{\s*,', '{', content)
    content = re.sub(r',\s*\}', '}', content)
    
    # Remove empty lines
    content = re.sub(r'\n\s*\n', '\n', content)
    
    with open(project_file, 'w') as f:
        f.write(content)
    
    print("Successfully removed widget extension from project file")
    print("You can now build and run the app without widget extension issues")

if __name__ == "__main__":
    remove_widget_extension()
