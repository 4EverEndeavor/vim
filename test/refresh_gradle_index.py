import os
import json

def generate_index(root_directory):
    gradle_to_file_index = {}
    file_to_gradle_index = {}

    for root, dirs, files in os.walk(root_directory):
        if 'build.gradle' in files:
            project_name = os.path.basename(root)
            gradle_home = os.path.abspath(root)
            tests = find_tests(root)
            gradle_to_file_index[project_name] = {
                'gradle_home': gradle_home,
                'tests': tests
            }
            for test in tests:
                file_to_gradle_index[test] = {
                    'gradle_home': gradle_home,
                    'project_name': project_name
                }

    return gradle_to_file_index, file_to_gradle_index

def find_tests(project_directory):
    tests = []
    # Add logic to find class and unit tests
    # For example, search for files matching a specific pattern
    for root, dirs, files in os.walk(project_directory):
        for file in files:
            if file.endswith(('.java')):
                test_path = os.path.relpath(os.path.join(root, file), project_directory)
                tests.append(test_path)

    return tests

if __name__ == "__main__":
    root_directory = "/Users/eric/Rhombus/"
    gradle_to_file_index, file_to_gradle_index = generate_index(root_directory)

    with open('gradle_to_file_index.json', 'w') as index_file:
        json.dump(gradle_to_file_index, index_file, indent=2)
    with open('file_to_gradle_index.json', 'w') as index_file:
        json.dump(file_to_gradle_index, index_file, indent=2)
