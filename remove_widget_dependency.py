#!/usr/bin/env python3
import re

def remove_widget_dependency(project_file):
    """Remove widget extension dependency from main app target"""
    
    with open(project_file, 'r') as f:
        content = f.read()
    
    # Remove the widget extension from Embed Foundation Extensions
    embed_pattern = r'8BF21E4F2E6F5BFE00221A8F /\* ManaTeluguWidgetsExtension\.appex in Embed Foundation Extensions \*/,?\s*'
    content = re.sub(embed_pattern, '', content)
    
    # Remove the build file reference for embedding
    build_file_pattern = r'8BF21E4F2E6F5BFE00221A8F /\* ManaTeluguWidgetsExtension\.appex in Embed Foundation Extensions \*/ = \{.*?\};'
    content = re.sub(build_file_pattern, '', content, flags=re.DOTALL)
    
    # Remove the file reference for the widget extension
    file_ref_pattern = r'8BF21E3F2E6F5BFD00221A8F /\* ManaTeluguWidgetsExtension\.appex \*/ = \{.*?\};'
    content = re.sub(file_ref_pattern, '', content, flags=re.DOTALL)
    
    # Remove the widget extension from products list
    products_pattern = r'8BF21E3F2E6F5BFD00221A8F /\* ManaTeluguWidgetsExtension\.appex \*/,?\s*'
    content = re.sub(products_pattern, '', content)
    
    # Clean up multiple newlines
    content = re.sub(r'\n\s*\n\s*\n', '\n\n', content)
    
    with open(project_file, 'w') as f:
        f.write(content)
    
    print("Successfully removed widget extension dependency from main app target")

if __name__ == "__main__":
    remove_widget_dependency("ManaTelugu.xcodeproj/project.pbxproj")
