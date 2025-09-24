#!/usr/bin/env python3
import re

def remove_widget_extension_target(project_file):
    """Remove ManaTeluguWidgetsExtension target from Xcode project file"""
    
    with open(project_file, 'r') as f:
        content = f.read()
    
    # Remove the widget extension target definition
    # Pattern to match the entire target block
    target_pattern = r'8BF21E3E2E6F5BFD00221A8F /\* ManaTeluguWidgetsExtension \*/ = \{.*?\};'
    content = re.sub(target_pattern, '', content, flags=re.DOTALL)
    
    # Remove widget extension from products list
    products_pattern = r'8BF21E3F2E6F5BFD00221A8F /\* ManaTeluguWidgetsExtension\.appex \*/,?\s*'
    content = re.sub(products_pattern, '', content)
    
    # Remove widget extension from build phases
    build_phase_pattern = r'8BF21E4F2E6F5BFE00221A8F /\* ManaTeluguWidgetsExtension\.appex in Embed Foundation Extensions \*/,?\s*'
    content = re.sub(build_phase_pattern, '', content)
    
    # Remove widget extension file references
    file_ref_pattern = r'8BF21E3F2E6F5BFD00221A8F /\* ManaTeluguWidgetsExtension\.appex \*/ = \{.*?\};'
    content = re.sub(file_ref_pattern, '', content, flags=re.DOTALL)
    
    # Remove widget extension build configuration
    build_config_pattern = r'8BF21E512E6F5BFE00221A8F /\* Build configuration list for PBXNativeTarget "ManaTeluguWidgetsExtension" \*/,?\s*'
    content = re.sub(build_config_pattern, '', content)
    
    # Remove widget extension from dependencies
    dependency_pattern = r'8BF21E3E2E6F5BFD00221A8F /\* ManaTeluguWidgetsExtension \*/,?\s*'
    content = re.sub(dependency_pattern, '', content)
    
    # Remove any remaining references to widget extension
    remaining_pattern = r'.*ManaTeluguWidgetsExtension.*\n'
    content = re.sub(remaining_pattern, '', content)
    
    # Clean up multiple newlines
    content = re.sub(r'\n\s*\n\s*\n', '\n\n', content)
    
    with open(project_file, 'w') as f:
        f.write(content)
    
    print("Successfully removed ManaTeluguWidgetsExtension target from project file")

if __name__ == "__main__":
    remove_widget_extension_target("ManaTelugu.xcodeproj/project.pbxproj")
