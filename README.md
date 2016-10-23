# IOS_MovieSearchApp
A simple Movie Searching App get's data from IMDB API. Also has the functions of saving favorite movies.

##Functions:
1. The app implements a tab bar with two tabs, one to search for movies, and the
other for their saved favorites. Each tab should have a custom image.<br/>
2. Data is pulled from the API and populated in a collection view. Each search should
return at least 20 movies (if possible).<br/>
3. Users can see the title and an image for each movie.<br/>
4. Images are cached to allow for smooth scrolling.<br/>
5. Selecting a movie pushes a new view controller with a larger image and at least 3
additional pieces of information about the movie (release year, rating, etc.)<br/>
6. The user can change the search query by editing a text field.<br/>
7, A spinner is shown when the data is being pulled from the API, and the request is
done in the background, not locking up the user interface.<br/>
8. Users can save a movie to their favorites.<br/>
9. Users can delete a movie from their favorites.<br/>
10. Favorites are maintained between app launches (data saved locally).<br/>
11. users can share the movie to their social networks.<br/>
12. display a message if there are no results<br/>
