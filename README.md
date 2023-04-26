Original App Design Project - README Template
===

# Be Fit

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description
This fitness app will help users track their workout and body weight: when they go to gym, how many time spend in the gym, how many calories do they burn, how weight is changed...

### App Evaluation

- **Category:** Fitness tracker/Healthy lifestyle
- **Mobile:** This fitness app is developed for iOS users and would utilize Xcode as development enviroment 
- **Story:** This fitness app is designed to motivate users to track and achive their fitness goals
- **Market:** This app is designed for those who want to lose weight and build muscle, and it has potential to cooperate with gyms
- **Habit:** This fitness app would encourage users to form healthy fitness habits by tracking progress and providing daily reminder and incentives to stay on track
- **Scope:** Our app can be more interactive by adding strech feastures like, connecting friends, ranking among friends...

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* User Must be able to log in/log out
* User must be able to register
* User information must be saved in Parse cloud
* There must be a homepage storyboard for user to interact with
    * Button for users to check in/check out
    * Button for users to record their workout
    * segment control to display daily/monthly/yearly workout time and calories burnt 
* A page for users to record what workout they did, how many time thy spent, how many calories burn


**Optional Nice-to-have Stories**

* Display which date did the users go to the gym and their contribution level using calendar feature(or similar to the way how github record daily contribution)
* Record users information(eg, weight, height...)
* Generate weekly/montly/yearly workout report

### 2. Screen Archetypes

* Log in
   * request username and password
   * after logging in, the log in status will persist until the user log out
* Sign 
    * request username, email, and password to sign up
* Main page
    * check in
    * workout record 
    * log out
    * segment control to display daily/monthly/yearly workout time and total calories burn
    * optional strech goal: display workout contribution level using grid features(similar to github)
    * optional stretch goal: user profile
* Sucessfully check-in
    * display info that sucessfully log in
* Workout Record Page
    * select activity
    * request enter of time and calories 
    * button to confirm
* User profile(optional strech goal)
    * modify name, age, weight, height...
    * upload user's photo


### 3. Navigation

**Tab Navigation** (Tab to Screen)


**Flow Navigation** (Screen to Screen)

* Login
   * ->Sign Up
   * ->Main
* Sign Up
   * ->Main
* Main 
    * -> succefully check-in page
    * ->workout record page
    * ->login
    * (optional)user profile page
* work out record page
    * ->main
* (Optional)user profile page
    * ->main
    * ->log in

## Wireframes
[Add picture of your hand sketched wireframes in this section]
<img src="https://i.imgur.com/8WUeWnT.png" width=600>
https://www.figma.com/file/BuTdlUAZ9LUVjFc4pOFJiF/BeFit-Wireframe?node-id=0-1



### [BONUS] Digital Wireframes & Mockups
![](https://i.imgur.com/NPcvvQY.png)



### [BONUS] Interactive Prototype

## Schema 
[This section will be completed in Unit 9]
### Models
* User
* Goals
### Networking
- [Add list of network requests by screen ]
- [Create basic snippets for each Parse network request]
- [OPTIONAL: List endpoints if using existing API such as Yelp]
