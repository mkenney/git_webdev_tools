Get Web Development Environment
===============================

Configure sub-projects (not submodules) to easily build out a development
environment.

1. Add this project as a submodule at the root of your web project with a path of git-webdev-tools
        $> git submodule add https://github.com/mkenney/git_webdev_tools.git git-webdev-tools

2. Copy the devsetup scripts to the root of your project and add them
        $> cp git-webdev-tools/devsetup.* .
        $> git add devsetup.*

3. Add any git projects you want checked out into this one.  This is convenient for large web projects
        $> echo "MODULE_URL[1]=https://github.com/mkenney/my_awesome_project.git" >> devsetup.conf
        $> echo "MODULE_path[1]=my/awesome/path" >> devsetup.conf
   This will clone my_awesome_project and put it in the my/awesome/path folder whenever devsetup.sh is 
   run.  It does not add it as a submodule.


https://github.com/mkenney/git_webdev_tools.git

