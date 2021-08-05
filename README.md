# FetchRewards Coding Exercise

## Requirements

- Use Xcode version 12.5.1 or higher
- Use iOS simulators which can run iOS 12.1 or higher
- Install CocoaPods
    - Install [ImageSlideshow](https://github.com/zvonicek/ImageSlideshow#readme) and [AlamofireImage](https://github.com/Alamofire/AlamofireImage)
    ```ruby
    pod 'ImageSlideshow', '~> 1.9.0'
    pod "ImageSlideshow/Alamofire"
    ```

## Features

When the app is initially launched, `EventController` does a event search with empty string as the query parameter.

The table view is divided into 2 sections: "Favorites", and "Search Results".

Each cell of the table view shows the image of the first performer, and name, type, location, and time of the event.

By tapping a table view cell, a detail screen of the corresponding event will be shown.

By tapping the favorite button, the event will be favorited or unfavorited. The changes are reflected in the table view by switching to the right section. Favorited events are persisted by `UserDefaults`.

The detail screen shows image slide show of all the performers, title of the event, date and time of the event, name of the venue, and the address of the venue.


## Design decisions

I decided to use `UserDefaults` to save favorited events. Another option would have been using Core Data. However, `UserDefaults` is capable enough to handle a dictionary of ID's, and is simpler to use. I used 2 sections for the table view. By having the first section as "Favorites", it would create a better user experience for the favorited events to show on top of the list, rather than having to scroll through the table view to find them.
