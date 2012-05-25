OVERVIEW

Despite being connected to hundreds of friends on Facebook, many people report feeling isolated. Asking friends to spend time with you one by one (via phone, SMS, e-mail, etc...) is feasible but it is painfully slow and cumbersome. Our system is designed to make it easy for people to send open invitations to their close group of friends (e.g. FYI, I will be working out in Dillon Gym from 3-4pm today). Glue is an iPhone app for people who do not want to crowd their friends inboxes with requests to hang out but who would like to have some company while they are working, going to the gym, or making dinner. 

Glue is not currently listed in the App Store.


FRONT-END (Pietro Rea, pietrorea@gmail.com)

Glue is an iPhone application built for iOS 5.1 (the latest version of the SDK as of this writing) using Xcode 4.3.2 on a machine running Mac OSX Version 10.7.3.The source code for Glue was written in Objective-C and was compiled using Xcode's built-in compiler, Apple LLVM compiler 3.1.

There are two important things to keep in mind about Glue's development environment. First, the source code makes use of Xcode's ARC functionality (automatic reference counting). ARC saves us the trouble of having to do any sort of memory management, which used to be a common source of frustration and bugs in iOS development.

Second, the source code also uses Storyboards. Storyboards lets us drag and drop user interface objects onto a canvas and to define segues between different views. Storyboards greatly simplify the task of creating the graphical user interface, which in the past used to be done programatically.

Some experienced iOS programmers still develop iOS apps with ARC and/or Storyboards turned off, which changes the nature of the source code substantially. It is important to know what these differences are if you are one of those programmers.

Glue's iOS source code consists of 35 files, all of which are included in the "Glue" subdirectory of the Xcode project. The file "MainStoryboard.storyboard" outlines the connections between different views and defines the graphical user interface for most of the app. However, it is important to keep in mind that there are some GUI elements that cannot be defined using Storyboards such as adding a "Delete Event" at the bottom of a dynamically-sized table (see EventDetailViewController.m for an example).

Every view in Glue is a customized Objective-C class with its own .h file and .m file. The .h file is the public interface that shows the properties (i.e. instance variables) and the public classes that the class can be called with. The .m file is the Objective-C implementation of the public methods as well as some private helper methods. Most views in the app needed to independent Objective-C classes to be able to support custom behavior.

For example, when you click on the app's fourth tab ("Friends"), the view that comes up is a subclass of UITableViewController called FriendsTableViewController. If you want to know which view corresponds to which class, simply click on a view in the Storyboard and pull up the "Indentity Inspector" in Xcode to see what class it corresponds to. Glue also has classes that do not correspond to any one object in the GUI. These classes (e.g. User and Event) represent abstract objects that we use to encapsulate data and methods.

Understanding how communication between objects works is also important for maintaining and developing Glue. To access information about the user that is currently logged in (e.g. name, e-mail), Glue uses a Singleton class called "SingletonUser" to represent the current user. In addition, if we want to pass certain information from one view to another, we usually do this via the method prepreForSegue. For instance, when a user taps on a Friend's row in the "Friends" screen, FriendsTableViewController sends the corresponding friend's details to FriendDetailViewController by calling prepareForSegue.

Another way objects communicate with each other in Glue is through delegation, a fundamental concept in iOS programming. To see an example of delegation, refer to the class InviteFriendCell. InviteFriendCell creates a delegation protocol that gets implemented by AddFriendsViewController.

Finally, most of the interaction with the back-end server is done through the SingletonUser class. The only server call that is done outside this class is createUser, which can be found in SignUpViewController. This is because a new user has to be created in the server before a SingletonClass object can be instantiated.

BACK-END (Alice Zheng, evolutia2001@gmail.com)

Glue is hosted on an Amazon EC2 instance running Red Hat EL6. The back-end is currently running on Apache 2.2.15 as configured in the last Virtual Host in /etc/httpd/conf/httpd.conf using an adapter located at /var/www/glue/adapter.wsgi.

Apache looks in /var/www/glue for all relevant files. The back-end code is located at /var/www/glue/glue.py and all data is stored in three json flat files: /var/www/glue/events.json, /var/www/glue/users.json, and /var/www/glue/auth.json. /var/www/glue/API documents all the public methods available to clients, the parameters they take, what they return, and what side-effects they have on the server state.

The server-side code is written in Python using the Bottle microframework, which essentially allows us to write functions to handle every supported request by attaching functions to routes. We also use Bottle to access GET parameters. For documentation and instructions on how to install Bottle, check this out.

Since all data is stored in flat files as json objects, the "database" is quite literally a dictionary of id to object mappings, so any user can be accessed by users[userid] where users = json.loads(open('users.json', 'r').read()). Helper functions for _like(a, b) and _starts_with(a, b) exist if you ever need to perform SQL-like queries as in the search_users method.


Credits:

iOS Development:      Pietro Rea
Back-end & Graphics:  Alice Zheng