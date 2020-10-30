import os
import json

from os import system

settings = None
verbose = True
manager = None
project_extension = "qpf"
project_settings_extensions = "qsf"

def is_allowed_extension(file):
    global settings

    # Check settings are available and that file is in fact a file
    if settings == None:
        return False
    if not os.path.isfile(file):
        return False
    
    file_information = file.split('.')
    file_extension = file_information[len(file_information) - 1]

    if file_extension in settings["allowed-extensions"]:
        return True

    return False

#----------------------------------
#Console wrappers
def log(strg):
    global verbose

    if verbose:
        print(strg)

def breakline(n):
    for i in range(n):
        print()

def title(text):
    breakline(1)
    print(text)
    for i in text:
        print('_', end='')
    print()

def clear():
    system('cls') # Clear console

def wait():
    breakline(1)
    exit = input("Press enter to proceed >>> ")

#-----------------------------------
#   PAGES
def component_descriptor():
    clear()
    title("Component descriptor")
    manager.print_components()
    while True:
        print(f"Select component to describe (enter number from (0 to {len(manager.components) -1}))")
        print(f"Other options")
        print(f"    q -> Quit component descriptor")
        print(f"    p -> Print components again")
        breakline(1)
        selection = input(" >>> ")

        if selection == 'q':
            break
        elif selection == 'p':
            clear()
            manager.print_components()
        
        try:
            manager.print_describe_component(int(selection))
        except:
            print("Incorrect entered value. Try again.")
            
def project_descriptor():
    clear()
    title("Project descriptor")
    manager.print_projects()
    while True:
        print(f"Select component to describe (enter number from (0 to {len(manager.projects) -1}))")
        print(f"Other options")
        print(f"    q -> Quit project descriptor")
        print(f"    p -> Print projects again")
        breakline(1)
        selection = input(" >>> ")

        if selection == 'q':
            break
        elif selection == 'p':
            clear()
            manager.print_projects()
        
        try:
            manager.print_describe_project(int(selection))
        except:
            print("Incorrect entered value. Try again.")

def select_project():
    project_idx = -1
    while True:
        manager.print_projects()
        breakline(1)
        print(f"Select project from the projects above. (enter number from (0 to {len(manager.projects) -1}))")
        print(f"Other options")
        print(f"    q -> Quit")
        breakline(1)
        selection = input(" >>> ")

        if selection == 'q':
            project_idx = -2
            break
        else:
            try:
                project_idx = int(selection)
                if project_idx > 0 and project_idx < len(manager.projects):
                    print(f"You have selected {project_idx}: {manager.projects[project_idx].name}")
                    break
                else:
                    print(f"Invalid selection. Please try again.")
            except:
                print("Incorrect entered value. Try again.")

    return project_idx

def parse_components_selection(selection):
    components_idx = []
    possible_idxs = selection.split(',')
    for possible_idx in possible_idxs:
        try:
            # Try single digit
            int_possible_idx = int(possible_idx)
            components_idx.append(int_possible_idx)
        except:
            # Try range
            possible_range = possible_idx.split('-')
            if len(possible_range) > 0:
                try:
                    start_idx = int(possible_range[0])
                    end_idx = int(possible_range[1])

                    # Define range
                    for i in range(start_idx, end_idx + 1):
                        components_idx.append(i)
                except:
                    print(f"Incorrect id: {possible_idx}. Ignoring it.")
            else:
                print(f"Incorrect id: {possible_idx}. Ignoring it.")

    return components_idx

def clean_components_idx(possible_components_idx):
    # Clean up components 
    components_idx = []
    for possible_idx in possible_components_idx:
        add_to_final_components = True
        if possible_idx < 0:
            add_to_final_components = False
        if possible_idx > len(manager.components) - 1:
            add_to_final_components = False

        if add_to_final_components:
            components_idx.append(possible_idx)

    return components_idx


def select_component():
    components_idx = []
    while True:
        manager.print_components()
        breakline(1)
        print(f"Select components from the components above. Available components: 0 to {len(manager.components) - 1}")
        print(f"To select you can enter the indexes, separated by comas. If they are in succesion you can enter n-m to select from component n to m.")
        print(f"You can also do a mixture of both. Examples:")
        print(f"    >>> 1,2,3-5 --> Selection of 1,2,3,4 and 5")
        print(f"    >>> 1,5     --> Selection of 1 and 5")
        print(f"Other options")
        print(f"    q -> Quit")
        breakline(1)
        selection = input(" >>> ")

        if selection == 'q':
            components_idx = "q"
            break
        else:
            try:
                possible_components_idx = parse_components_selection(selection)
                components_idx = clean_components_idx(possible_components_idx)

                if len(components_idx) > 0:
                    print("You have selected the components: ")
                    for component_idx in components_idx:
                        print(f"    {component_idx}: {manager.components[component_idx].name}")
                    breakline(1)
                    break
            except:
                print("Incorrect entered value. Try again.")

    return components_idx

def export_components_to_project(project_idx, components_idx):
    project = manager.projects[project_idx]
    if verbose:
        print(f"Exporting to project: {project.name}")
    for i in components_idx:
        component = manager.components[i]
        if verbose:
            print(f"    Copying files of {component.name}")
        
        for file in component.files:
            os.popen(f"copy {file} {project.path}")

        if verbose:
            print(f"    Updating project's settings file")

        for filename in component.filenames:
            project.add_file(filename)

    if verbose:
        print(f"Components have been exported succesfully")
        
        

def component_export():
    clear()
    title("Component exporter")
    while True:
        project_idx = -1
        while project_idx == -1:
            project_idx = select_project()
            if project_idx == -2:
                break
            
            print(f"Press enter to continue")
            print(f"Other options")
            print(f"    r -> Select again")
            breakline(1)
            selection = input(" >>> ")
            if selection == 'r':
                project_idx = -1

        if project_idx == -2:
            break

        components_idx = []
        while len(components_idx) == 0:
            components_idx = select_component()
            if components_idx == 'q':
                break

            print(f"Press enter to continue")
            print(f"Other options")
            print(f"    r -> Select again")
            breakline(1)
            selection = input(" >>> ")
            if selection == 'r':
                components_idx = []

        if len(components_idx) == 0:
            break
        
        print("Exporting components to project")
        export_components_to_project(project_idx, components_idx)
        wait()

def autoinitialize_components():
    clear()
    title("Autoinitializer of files")
    while True:
        project_idx = -1
        while project_idx == -1:
            project_idx = select_project()
            if project_idx == -2:
                break
            
            print(f"Press enter to continue")
            print(f"Other options")
            print(f"    r -> Select again")
            breakline(1)
            selection = input(" >>> ")
            if selection == 'r':
                project_idx = -1

        if project_idx == -2:
            break
        
        project = manager.projects[project_idx]
        initialized_components = project.get_initialized_components()
        is_component, files, filenames = manager.get_component_files(project.path)
        
        breakline(1)
        print(f"Autonitializing all files")
        for filename in filenames:
            if filename not in initialized_components:
                project.add_file(filename)

                if verbose:
                    print(f"    {filename} was not initialized. Initialzing.")
        
        wait()

def menu():
    while True:
        clear()
        title("Please select one:")

        # Options
        print(f"    0 -> Export components to project")
        print(f"    1 -> Show components")
        if len(manager.components) > 0:
            print(f"    2 -> Describe components")
        print(f"    3 -> Show projects")
        if len(manager.projects) > 0:
            print(f"    4 -> Describe project")
        print(f"    5 -> Refresh components and projects")
        print(f"    6 -> Auto initialize all files in a project")
        breakline(1)
        print(f"    q -> Quit")
        # Menu input
        breakline(2)
        option = input(" >>> ").lower()
        # Input handler
        if option == '0':
            component_export()
        elif option == '1':
            clear()
            title("Components")
            manager.print_components()
            wait()
        elif option == '2':
            component_descriptor()
        elif option == '3':
            clear()
            title("Projects")
            manager.print_projects()
            wait()
        elif option == '4':
            project_descriptor()
        elif option == '5':
            clear()
            title("Refreshing components and projects")
            manager.get_components()
            manager.get_projects()
            wait()
        elif option == '6':
            autoinitialize_components()
        elif option == 'q':
            break
    
class Component:
    def __init__(self, name, path):
        self.name = name
        self.path = path
        
        self.files = []
        self.filenames = []

class Project:
    def __init__(self, name, path):
        self.name = name
        self.path = path

        self.initialized_components = []
        self.initialized_component_prefix = "set_global_assignment -name VHDL_FILE"

    def get_initialized_components(self):
        settings_file = os.path.join(self.path, self.name + '.' + project_settings_extensions)
        if not os.path.isfile(settings_file):
            print(f"Settings file of project {self.name} is missing.")
            return None

        settings = []
        with open(settings_file, 'r') as f:
            settings = f.readlines()

        initialized_components = []
        for settings_line in settings:
            prefix = self.initialized_component_prefix
            idx = settings_line.find(prefix)
            if idx >= 0:
                component_name = list(settings_line)[idx+len(prefix)+1:len(settings_line) - 1]
                component_name = "".join(component_name)
                initialized_components.append(component_name)

        self.initialized_components = initialized_components
        return initialized_components

    def add_file(self, name):
        settings_file = os.path.join(self.path, self.name + '.' + project_settings_extensions)
        if not os.path.isfile(settings_file):
            print(f"Settings file of project {self.name} is missing.")
            return None

        with open(settings_file, 'a') as f:
            f.writelines(["\n" + self.initialized_component_prefix + " " + name])

class Manager:
    def __init__(self, settings):
        self.settings = settings
        
        # Manager variables
        self.components = []
        self.projects = []
    
    # Go through each folder checking for components
    def get_components(self):
        log("Retreiving components from 'components-folders'")
        for component_folder in self.settings["components-folders"]:
            if component_folder == ".":
                component_folder = os.getcwd()
            
            components = self.get_components_in_folder(component_folder)
            self.components.extend(components)

    # Inside each folder that may contain multiple components, check for components
    def get_components_in_folder(self, folder):
        if not os.path.isdir(folder):
            print(f"This path is not a folder: '{folder}''. Please modify settings.json -> components-folders and enter a valid path.")
            return

        working_dir = os.getcwd()
        os.chdir(folder)

        components = []
        for root, test_folders, files in os.walk('.'):
            for test_folder in test_folders:
                # Check if there are any component files
                test_folder_path = os.path.join(folder, test_folder)
                is_component, files, filenames = self.get_component_files(test_folder_path)

                # If the test_folder contains components, add them
                if is_component and test_folder not in self.settings["exclude-components"]:
                    component = Component(test_folder, test_folder_path)
                    component.files = files
                    component.filenames = filenames
                    components.append(component)

        os.chdir(working_dir)
        return components
    
    def get_component_files(self, folder):
        if not os.path.isdir(folder):
            return False, None, None

        working_dir = os.getcwd()
        os.chdir(folder)

        # Information to be saved
        files = []
        filenames = []
        # Check for files in folder with allowed extensions
        for root, folders, test_files in os.walk('.'):
            for test_file in test_files:
                if is_allowed_extension(test_file): 
                    files.append(os.path.join(folder, test_file))
                    filenames.append(test_file)

        # Return to last dir
        os.chdir(working_dir)
        if len(files) > 0:
            return True, files, filenames
        else:
            return False, None, None

    def clear_components(self):
        self.components = []

    def get_projects(self):
        log("Retreiving components from 'project-folders'")
        for project_folder in self.settings["project-folders"]:
            if project_folder == ".":
                project_folder = os.getcwd()
            
            projects = self.get_projects_in_folder(project_folder)
            self.projects.extend(projects)
    
    def get_projects_in_folder(self, folder):
        if not os.path.isdir(folder):
            print(f"This path is not a folder: '{folder}''. Please modify settings.json -> project-folders and enter a valid path.")
            return

        working_dir = os.getcwd()
        os.chdir(folder)

        projects = []
        for root, test_folders, files in os.walk('.'):
            for test_folder in test_folders:
                test_folder_path = os.path.join(folder, test_folder)
                is_project = self.is_project(test_folder_path)
                
                if is_project and test_folder not in self.settings["exclude-projects"]:
                    project = Project(test_folder, test_folder_path)
                    projects.append(project)

        os.chdir(working_dir)
        return projects

    def is_project(self, test_folder):
        if not os.path.isdir(test_folder):
            return False

        working_dir = os.getcwd()
        os.chdir(test_folder)

        for root, folder, test_files in os.walk('.'):
            for file in test_files:
                file_information = file.split('.')
                file_extension = file_information[len(file_information) - 1]

                if file_extension == project_extension:
                    return True

        os.chdir(working_dir)
        return False


    def print_describe_component(self, component_idx):
        if len(self.components) == 0:
            print("There are no components")
        elif len(self.components) - 1 < component_idx:
            print("Invalid component id (too big).")
        elif component_idx < 0:
            print("Invalid component id (negative.")

        component = self.components[component_idx]
        breakline(1)
        print(f"Component: {component.name}")
        print(f"    Modules:")
        for i, filename in enumerate(component.filenames):
            print(f"        {i} - {filename}")
        breakline(1)
        print(f"    Total modules: {len(component.filenames)}")
        print(f"    Location: {component.path}")
        breakline(2)

    def print_components(self):
        if len(self.components) == 0:
            print("Empty")
        else:
            breakline(1)
            for j, component in enumerate(self.components):
                print(f"{j}. {component.name}")
            breakline(1)

    def print_describe_project(self, project_idx):
        if len(self.projects) == 0:
            print("There are no projects")
        elif len(self.projects) - 1 < project_idx:
            print("Invalid project id (too big).")
        elif project_idx < 0:
            print("Invalid project id (negative).")

        project = self.projects[project_idx]
        breakline(1)
        print(f"Project: {project.name}")
        print(f"    Initialized components:")
        project.get_initialized_components()
        for i, name in enumerate(project.initialized_components):
            print(f"        {i} - {name}")
        breakline(1)
        print(f"    Total initialized components: {len(project.initialized_components)}")
        print(f"    Location: {project.path}")
        breakline(2)

    def print_projects(self):
        if len(self.projects) == 0:
            print("Empty")
        else:
            breakline(1)
            for j, project in enumerate(self.projects):
                print(f"{j}. {project.name}")
            breakline(1)

if __name__ == '__main__':
    working_dir = os.getcwd()
    settings_path = os.path.join(working_dir, "settings.json")
    if not os.path.isfile(settings_path):
        print("Error! Settings not defined")
    else:
        with open(settings_path, 'r') as raw_settings:
            settings = json.loads(raw_settings.read())
        verbose = settings["verbose"]
        
        manager = Manager(settings)
        manager.get_components()
        manager.get_projects()

        menu()
