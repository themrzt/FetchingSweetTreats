# FetchingSweetTreats
"Sweet Treats" is an example app for playing with the [The Meal DB](https://www.themealdb.com/api.php). 

## Features
This repo currently features a thin implementation of Swift networking using structured concurrency. It allows you to view and dive into details on 100 dessert recipes from the Meal DB.

## Transforming Recipes
The Meal DB API currently uses up to 20 optional keys each for ingredients and measures. To make managing these easier, "Sweet Treats" uses an **Ingredient** struct to encode both the name and measurement of ingredients, making these properties on **Recipe** structs. Recipe structs are in turn inflated as details on the **MealViewModel** for display.

## Areas for Future Improvement
* The implementation of fetching the meals by category and then their details is simply _begging_ for a more robust solution. I've not spent enough time learning about task groups with structured concurrency. That's an area I'd like to spend time on in the future. The Meal DB frequently threw rate limits when trying to pull both simultaneously.
* In this first implementation, I'm not as proud of the iPad's detail view as I'd like. There's more to be done there to make a good user experience.
* Thinking broader, this app could be a good candidate for adding Core Data as a persistence layer. It may also prove a good testing ground for SwiftData. While there's UserDefaults present here, Core/Swift Data offers perhaps a better opportunity to deploy filter support by region, ingredients, etc.
* More complete unit tests. I'm a recent convert to test-driven-development after another project asked for more complex model mapping and integration. Sweet Treats doesn't reflect this.
* Complete the Region Detail List to provide a way of exploring desserts by geographic region. (Implementation started)
* Add a random dessert widget. (Because it'd be pretty...sweet)
* **Speaking of widgets...** there's a cool Live Activity opportunity here with iOS 17. Use the new interaction model for widgets and progress step-by-step on a device through a recipe.
