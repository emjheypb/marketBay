//
//  FirebaseConstants.swift
//  marketBay
//
//  Created by EmJhey PB on 2/27/24.
//

import Foundation

enum FirebaseConstants: String {
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
    
    case COLLECTION_LISTINGS = "Listings"
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
