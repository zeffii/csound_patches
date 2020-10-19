

def print_version_of_system_python():
    import platform
    import os
    print(platform.python_version())

    os.system("python -V")

    try:
        user_paths = os.environ['PYTHONPATH'].split(os.pathsep)
    except KeyError:
        user_paths = []

    print("PYTHONPATH:", user_paths)

    try:
        user_paths = os.environ['Path'].split(os.pathsep)
    except KeyError:
        user_paths = []

    print("Path:", user_paths)


print_version_of_system_python()