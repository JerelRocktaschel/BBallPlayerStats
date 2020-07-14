# BBallPlayerStats

This GitHub page will serve as both the product page for the BBall Players Stats App as well as provide technical information about how the app was built.

## Product Information

iPhone app that retrieves all current players from the NBA, sorts players alphabetically by last name and by team and displays a player detail view.

Each player stats detail view presents a pic of the player, jersey and position, demographics and season statistics. Select the favorite button to tag your favorite players and selecting the star button on the players list will show only your favorite players.

I built this app for a few reasons. I love the NBA and have been a fan for over three decades. I wanted to increase my Swift knowledge and I learn quicker when working on a real project as opposed to book learning. 

I do have a few additional feature ideas for this app and may end up implementing those in a subsequent release.

## Privacy Policy

The BBall Players Stats App collects no personal information at all. Zip. Nada.
 
[![Available on the App Store](http://cl.ly/WouG/Download_on_the_App_Store_Badge_US-UK_135x40.svg)](https://apps.apple.com/app/id1522364788)

## What is under the hood

So this app started as one thing in my mind and went through several iterations to get here, which has led to implementing a number of features:

![Image of Stefon](https://media3.giphy.com/media/XaFX9e9xfbcXWxW0a2/giphy.gif)

* 100% Swift
* MVVM+C mostly - a little MVP as well
* Simple network layer using Decodable for JSON processing
* NBA API calls for player and team data and a call to ESPN for NBA logos
* Core Data storage layer 
* NSFetchedResultsController
* UIResultSearchController
* NSAttributedString
* Image Caching
* Dispatch Queues for handling simultaneous API calls
* Auto Layout in Xib and code
* Centralized error handling
* Object Association
* Resources enum defines all resources utilized throughout app for parameterization
* Zero dependencies

![Image of Stefon](https://images.squarespace-cdn.com/content/v1/5e2ca76d3df0a85f43d5341b/1594738829649-5N2EATCEOTJSLHWBCL2X/ke17ZwdGBToddI8pDm48kLnfZvQ9iwxKU6eubAUQjId7gQa3H78H3Y0txjaiv_0fDoOvxcdMmMKkDsyUqMSsMWxHk725yiiHCCLfrh8O1z5QPOohDIaIeljMHgDF5CVlOqpeNLcJ80NK65_fV7S1UZu4EA4VkQXskbAiP4Lo2GV8HD7TW41NQmswmX4LjmCLoRwB-dUGsSquCnVTFQcaRg/BBallPlayerStats_Resized.png)
