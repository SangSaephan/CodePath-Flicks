# Project 1 - *Flicks*

**Flicks** is a movies app using the [The Movie Database API](http://docs.themoviedb.apiary.io/#).

Time spent: **9.5** hours spent in total

## User Stories

The following **required** functionality is complete:

- [X] User can view a list of movies currently playing in theaters from The Movie Database.
- [X] Poster images are loaded using the UIImageView category in the AFNetworking library.
- [X] User sees a loading state while waiting for the movies API.
- [X] User can pull to refresh the movie list.

The following **optional** features are implemented:

- [X] User sees an error message when there's a networking error.
- [X] Movies are displayed using a CollectionView instead of a TableView.
- [X] User can search for a movie.
- [X] All images fade in as they are loading.
- [X] Customize the UI.

The following **additional** features are implemented:

- [X] Modify API endpoint to retrieve more accurate results.
- [X] Implement Auto Layout.
- [X] Add app icon and launch screen.

Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1. Better way to implement the network error.
2. Extend the app by adding additional movie info.

## Video Walkthrough 

Here's a walkthrough of implemented user stories:

![](Flicks.gif)

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

I had some trouble implementing the search bar. The example given filtered an array of Strings, whereas we had to filter an array of NSDictionary.

## License

    Copyright [2017] [Sang Saephan]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.

# Project 2 - *Flicks*

**Flicks** is a movies app displaying box office and top rental DVDs using [The Movie Database API](http://docs.themoviedb.apiary.io/#).

Time spent: **15** hours spent in total

## User Stories

The following **required** functionality is completed:

- [X] User can view movie details by tapping on a cell.
- [X] User can select from a tab bar for either **Now Playing** or **Top Rated** movies.
- [X] Customize the selection effect of the cell.

The following **optional** features are implemented:

- [X] For the large poster, load the low resolution image first and then switch to the high resolution image when complete.
- [X] Customize the navigation bar.

The following **additional** features are implemented:

- [X] Add "Upcoming" tab bar item.
- [X] Allow movie overview to scroll if the text is too long.
- [X] Add rounded corners for collection view cells.
- [X] User can sort movies alphabetically or by release date.

Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1. Add addition movie information (e.g. runtime, rating, genre, etc.).
2. Maybe add in a placeholder image in case some images are nil.

## Video Walkthrough 

Here's a walkthrough of implemented user stories:

![](Flicks3.gif)

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

I ran into some issues with the URL returning nil. I initially declared the "endPoint" variable as an unwrapped optional, and XCode wasn't giving me any errors, so I didn't know I had to unwrap it inside the URL as well.

## License

    Copyright [2017] [Sang Saephan]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
