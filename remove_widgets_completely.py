#!/usr/bin/env python3
import re

def remove_widgets_completely(project_file):
    """Remove all widget-related code from Xcode project file"""
    
    with open(project_file, 'r') as f:
        content = f.read()
    
    # Remove all lines containing ManaTeluguWidgetsExtension
    content = re.sub(r'.*ManaTeluguWidgetsExtension.*\n', '', content)
    
    # Remove all lines containing ManaTeluguWidgets
    content = re.sub(r'.*ManaTeluguWidgets.*\n', '', content)
    
    # Remove all lines containing WidgetKit
    content = re.sub(r'.*WidgetKit.*\n', '', content)
    
    # Remove all lines containing SwiftUI framework references
    content = re.sub(r'.*SwiftUI\.framework.*\n', '', content)
    
    # Remove all lines containing PBXFileSystemSynchronizedBuildFileExceptionSet
    content = re.sub(r'.*PBXFileSystemSynchronizedBuildFileExceptionSet.*\n', '', content)
    
    # Remove all lines containing PBXFileSystemSynchronizedRootGroup
    content = re.sub(r'.*PBXFileSystemSynchronizedRootGroup.*\n', '', content)
    
    # Remove all lines containing Embed Foundation Extensions
    content = re.sub(r'.*Embed Foundation Extensions.*\n', '', content)
    
    # Remove all lines containing appex references
    content = re.sub(r'.*\.appex.*\n', '', content)
    
    # Clean up multiple newlines
    content = re.sub(r'\n\s*\n\s*\n', '\n\n', content)
    
    # Remove empty sections
    content = re.sub(r'/\* Begin PBXFileSystemSynchronizedBuildFileExceptionSet section \*/\n/\* End PBXFileSystemSynchronizedBuildFileExceptionSet section \*/\n', '', content)
    content = re.sub(r'/\* Begin PBXFileSystemSynchronizedRootGroup section \*/\n.*?/\* End PBXFileSystemSynchronizedRootGroup section \*/\n', '', content, flags=re.DOTALL)
    
    with open(project_file, 'w') as f:
        f.write(content)
    
    print("Successfully removed all widget-related code from project file")

if __name__ == "__main__":
    remove_widgets_completely("ManaTelugu.xcodeproj/project.pbxproj")
