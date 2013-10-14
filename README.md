LetoTest
========

This test was very entertaining, I enjoyed doing it.

Before starting the test, I have done a little bit of preparation. I have analysed the XML and JSON that the application has to parse, so that I know exactly what I have to extract, so therefore I don't lose any time trying to figure it out while coding. I also made a little sketch of the user interface and defined the entity.

I have selected the Master-Detail Application as I think it is the most suitable for listing the films. I also noticed while analysing the BBC iPlayer XML that there was a link to a web page for each movie, therefore, I chose to show this page in the detail view of the app.

I have defined that the entity class Film would contain the following ivars: title, URL, desc, imageURL, score, rating. And I added afterward the UIImage of the thumbnail image. The desc property is actually unnecessary, and is not used.

I chose to use TBXML to parse XML, and SBJSON to parse JSON. And I made a diagram of the element I wanted to grab in the data structure so it's very clear and easier to code the parsing.

I have added the in-built "pull to refresh" to the UITableViewController so we can refresh the list of films manually. The thumbnail images are loaded asynchronously and resized to look good inside the UITableViewCell.

Unfortunately I didn't have time to add a button to select between the different sorting (alphabetically or Rotten Tomatoes score). And also I wanted to show the Rotten Tomatoes score and rating inside the UITableViewCell, but I didn't do it.

Despite that, the base project is done along with most of the bonus points.
