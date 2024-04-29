# assumes you heve the azurecyclecloud cli installed (it is on the cyclecloud server)
cyclecloudProjectFolderName=cyclecloudprojects
cyclecloudProjectName=project01
cyclecloudTemplateName=template01


# find out what the locker is
cyclecloud locker list

# cd to the directory where you keep your templates, this is probably something like $HOME/cyclecloud_projects, if this is het first project, craete the directory in your home folder
mkdir $HOME/$cyclecloudProjectFolderName
cd $HOME/$cyclecloudProjectFolderName

# Create a new project (you will need to know the locker name)
cyclecloud project init $cyclecloudProjectName

# Create a new template
cd $HOME/$cyclecloudProjectFolderName/$cyclecloudProjectName
cyclecloud project generate_template templates/$cyclecloudTemplateName.template.txt

# edit the template file to your liking by editing the txt file
nano templates/$cyclecloudTemplateName.template.txt


#once the template is ready, import it to cyclecloud
cyclecloud import_template -f $HOME/$cyclecloudProjectFolderName/$cyclecloudProjectName/templates/$cyclecloudTemplateName.template.txt
cd $HOME/$cyclecloudProjectFolderName/$cyclecloudProjectName
cyclecloud project upload
cd $HOME

#create a cluster based on the template
cyclecloud create_cluster $cyclecloudProjectName 'New Cluster'