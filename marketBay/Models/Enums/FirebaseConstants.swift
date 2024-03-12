//
//  FirebaseConstants.swift
//  marketBay
//
//  Created by EmJhey PB on 2/27/24.
//

import Foundation

enum FirebaseConstants: String {
    // MARK: USERS
    case COLLECTION_USERS = "Users"
    case COLLECTION_USER_LISTINGS = "User_Listings"
    case COLLECTION_USER_FAVORITES = "User_Favorites"
    case COLLECTION_USER_COLLECTIONS = "User_Collections"
    case COLLECTION_USER_CHATROOMS = "User_Chatrooms"
    /*
     "Users" : {
        "userID1" : {
            User class,
            "User_Favorites" : {
                "listingID1" : {
                    MiniListing class
                },
                "listingID2" : {
                    MiniListing class
                },
                ...
            },
            "User_Collections" : {
                "collectionName1" : {
                    "listingID1" : {
                        MiniListing class
                    },
                    ...
                },
                "collectionName1" : {
                    "listingID2" : {
                        MiniListing class
                    },
                    ...
                },
                ...
            },
            "User_Chatrooms" : {
                "chatroomID1" : true,
                "chatroomID3" : false, // archived
                ...
            },
        },
        "userID2" : {
            User class,
            "User_Listings" : {
                "listingID1" : {
                    MiniListing class
                },
                "listingID3" : {
                    MiniListing class
                },
                ...
            },
            "User_Chatrooms" : {
                "chatroomID1" : true,
                "chatroomID2" : false, / /archived
                ...
            },
        },
        ...
     }
     */
    
    // MARK: LISTINGS
    case COLLECTION_LISTINGS = "Listings"
    case FIELD_LISTING_TITLE = "title"
    case FIELD_LISTING_DESCRIPTION = "description"
    case FIELD_LISTING_CATEGORY = "category"
    case FIELD_LISTING_PRICE = "price"
    case FIELD_LISTING_STATUS = "status"
    case FIELD_LISTING_FAVORITECOUNT = "favoriteCount"
    case FIELD_LISTING_MINI_USER_NAME = "name"
    case FIELD_LISTING_MINI_USER_EMAIL = "email"
    case FIELD_LISTING_MINI_USER_PHONE = "phone"
    case FIELD_LISTING_IMAGE = "image"
    /*
     "Listings" : {
        "listingID1" : {
            Listing class
        },
        "listingID2" : {
            Listing class
        },
        ...
     }
     */
    
    // MARK: CHATROOMS
    case COLLECTION_CHATROOMS = "Chatrooms"
    /*
     "Chatrooms" : {
        "chatroomID1" : {
            Chatroom class
        },
        "chatroomID2" : {
            Chatroom class
        },
        ...
     }
     */
    
    // MARK: CHATS
    case COLLECITON_CHATS = "Chats"
    /*
     "Chats" : {
        "chatroomID1" : {
            "chatID1" : {
                Chat class
            },
            "chatID2" : {
                Chat class
            },
            ...
        },
        "chatroomID2" : {
            "chatID1" : {
                Chat class
            },
            "chatID2" : {
                Chat class
            },
            ...
        },
        ...
     }
     */
}
