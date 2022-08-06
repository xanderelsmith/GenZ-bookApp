# book_app

# Flutter

[](https://www.back4app.com/docs/flutter/parse-sdk/data-objects/flutter-one-to-many-relationship#more)## One to many Relationship on Flutter

### Introduction

Using Parse, you can store data objects establishing relations between them. To model this behavior, any `ParseObject` can be used as a value in other `ParseObject`. Internally, the Parse framework will store the referred-to object in just one place, to maintain consistency. That can give you extra power when building and running complex queries. There are three main relation types:

* `one-to-one`, establishing direct relations between two objects and only them;
* `one-to-many`, where one object can be related to many other objects;
* `many-to-many`, which can create many complex relations between many objects.

In this guide we will detail how the `one-to-many` relation works using a pratical app example. There are two ways to create a `one-to-many` relation in Parse:

* The first is using the `Pointers` in `Child Class`, which is the fastest in creation and query time.
* The second is using `Arrays` of `Pointers` in Parent Class which can lead to slow query times depending on their size. Because of this performance issue, we will use only pointers examples.

You will implement a Flutter book registration App and will create and query related objects using the Parse `Pointers`.

> Relation as `one-to-one` is not common and we are not going to cover on our guides. As an example a relationship between the User class and another class that will contain sensitive user data for [security reasons](https://blog.back4app.com/parse-server-best-practices/) ( *1.4. Don’t let users have access to sensitive data from others* ).

<iframe width="560" height="315" src="https://www.youtube.com/embed/b6fdFD0hlJo" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen=""></iframe>

### Prerequisites

> **To complete this tutorial, you will need:**
>
> * [Android Studio](https://developer.android.com/studio) or [VS Code installed](https://code.visualstudio.com/) (with [Plugins](https://flutter.dev/docs/get-started/editor) Dart and Flutter)
> * An app created on Back4App.
>   * **Note:** Follow the [New Parse App Tutorial](https://www.back4app.com/docs/get-started/new-parse-app) to learn how to create a Parse App on Back4App.
> * An Flutter app connected to Back4app.
>   * **Note:** Follow the [Install Parse SDK on Flutter project](https://www.back4app.com/docs/flutter/parse-sdk/parse-flutter-sdk "Create New App Tutorial") to create an Flutter Project connected to Back4App.
> * A device (or virtual device) running Android or iOS.

### Understanding the Book App

The main object class you’ll be using is the `Book` class, storing each book entry in the registration. Also, these are the other three object classes:

* `Publisher`: book publisher name, one-to-many relation with `Book`;
* `Genre`: book genre, one-to-many relation with `Book`. Note that for this example we will consider that a book can only have one genre;
* `Author`: book author, many-to-many relation with `Book`, since a book can have more than one author and an author can have more than one book as well;

A visual representation of these data modeltutorials,

samples, guidance on mobile development, and a full API reference.
